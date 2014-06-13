//
//  RJTouch.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/3/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "RJTouch.h"

#import "Physics.h"

#import "Game.h"

#import "Actioner.h"

#import "BaseGameElement.h"
#import "JumpBase.h"
#import "JumpPlateforme.h"

#import "Bipede.h"
#import "Fall.h"

#import "Display.h"
#import "Screen.h"
#import "DisplayObject.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"
#import "BorderedCCSprite.h"

#import "PlayerData.h"

#import "CollidObject.h"

#import "Bipede.h"

@implementation RJTouch

@synthesize fromTouchPos;
@synthesize currentTouchPos;

@synthesize touch;

- (id)initWithGame:(Game *)_game player:(NSInteger)_player batch:(CCSpriteBatchNode *)batch {
	if (self = [super init]) {
		fromJumpBases = [[NSMutableArray array] retain];
		
		game = _game;
		player = _player;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
        
        for (int i = 0; i < sizeof(pathSprite) / sizeof(CCSprite *); ++i) {
			pathSprite[i] = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"jumpb%d_%d.png", player + 1, ((i % 14) + 1)]];
			pathSprite[i].opacity = 127;
			pathSprite[i].anchorPoint = ccp(0.5, 0);
			pathSprite[i].visible = NO;
			[batch addChild:pathSprite[i]];
		}
        
        jumpBaseSprite = [BorderedCCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"palette_%d__%d.png", player + 1, game.playerData[player].jumpBaseLevel]];
        jumpBaseSprite.anchorPoint = ccp(0.5, 1.0);
        jumpBaseSprite.opacity = 127;
        [[Display sharedDisplay].screens[player].frontNode addChild:jumpBaseSprite];

	}
	return self;
}

- (void)update:(ccTime)dt {
    if (didMove) {
        if (!currentJumpBase)
            [self avoidOverLap];
        [self drawPath];
    }
    time += dt;
}

- (BOOL)touchBegan:(UITouch *)_touch withEvent:(UIEvent *)event {
	touch = _touch;
	CGPoint newPos = [[Display sharedDisplay].screens[player].scrollNode convertTouchToNodeSpace:touch];
	
	JumpBase *tmp = [self findNeutralJumpBase:newPos checkCanHaveNext:YES limitDist:NO];
	
	if (tmp) {
        [fromJumpBases addObject:tmp];
        CGRect collidRect = [tmp collidRect];
        isOK = NO;
        didMove = NO;
        fromTouchPos = ccp((newPos.x < collidRect.origin.x ? collidRect.origin.x : (newPos.x > collidRect.origin.x + collidRect.size.width ? collidRect.origin.x + collidRect.size.width : newPos.x)), collidRect.origin.y + collidRect.size.height);
        
        CGFloat dist = ccpDistance(newPos, fromTouchPos);
        if (dist > game.playerData[player].maxJumpDistance) {
            newPos = ccpAdd(fromTouchPos, ccpMult(ccpNormalize(ccpSub(newPos, fromTouchPos)), game.playerData[player].maxJumpDistance));
        }
        
        currentTouchPos = newPos;
        jumpBaseSprite.borderColor = color_array[tmp.color];
	}
	
	return tmp != nil;
}

- (void)touchMoved:(UITouch *)_touch withEvent:(UIEvent *)event {
    CGPoint newPos = [[Display sharedDisplay].screens[player].scrollNode convertTouchToNodeSpace:touch];
    newPos.y = newPos.y > [Display sharedDisplay].size.height - 50 ? [Display sharedDisplay].size.height - 50 : newPos.y;
    CGFloat dist = ccpDistance(newPos, fromTouchPos);
    
    if (dist > game.playerData[player].maxJumpDistance) {
        newPos = ccpAdd(fromTouchPos, ccpMult(ccpNormalize(ccpSub(newPos, fromTouchPos)), game.playerData[player].maxJumpDistance));
    }
    
    JumpBase *tmp = [self findNeutralJumpBase:newPos checkCanHaveNext:NO limitDist:YES];
    [currentJumpBase release];
    currentJumpBase = [tmp retain];
    if (tmp) {
        CGRect collidRect = [tmp collidRect];
        currentTouchPos = ccp(newPos.x, collidRect.origin.y + collidRect.size.height);
        isOK = YES;
    } else {
        currentTouchPos = newPos;
        [self avoidOverLap];
    }
    didMove = YES;
}

- (void)touchEnded:(UITouch *)_touch withEvent:(UIEvent *)event {
    JumpBase *touched;
    if ((touched = [self isInsideFromJB])) {
        if (touched.isDeletable && game.gameTime - touched.lastTouch < 0.2) {
            [touched.onBoard iterateOrRemove:^BOOL(id entry) {
                Bipede *bipede = entry;
                [bipede currentJumpBaseDeleted];
                Fall *fall = [[Fall alloc] initWithBipede:bipede game:game];
                [bipede.actioner setCurrentAction:fall interrupted:YES];
                [fall release];
                return NO;
            } removeOnYES:NO exit:NO];
            [game.jumpBases iterateOrRemove:^BOOL(id entry) {
                return entry == touched;
            } removeOnYES:YES exit:YES];
            return;
        }
        touched.lastTouch = game.gameTime;
        return;
    }
    if (!isOK || !didMove)
        return;
    if (!currentJumpBase) {
        JumpPlateforme *jumpPlateforme = [[JumpPlateforme alloc] initWithPlayer:player level:realJumpBaseLvl game:game];
        jumpPlateforme.sprite.position = realJumpBasePos;
        [jumpPlateforme activate];

        [game.jumpBases addEntry:jumpPlateforme];
        
        [jumpPlateforme release];
        
        CGRect collidRect = [jumpPlateforme collidRect];
        
        for (JumpBase *fromJumpBase in fromJumpBases) {
            CGRect fromCollidRect = [fromJumpBase collidRect];
            CGPoint from = ccpSub(ccp(fromTouchPos.x, fromCollidRect.origin.y + fromCollidRect.size.height), fromCollidRect.origin);
            CGPoint to = ccpSub(currentTouchPos, collidRect.origin);
            [fromJumpBase addNextForPlayer:player jumpBase:jumpPlateforme fromPos:from toPos:to];
        }
        [game.playerData[player] addStat:STAT_JUMPBASE_CREATED n:1 pts:JUMPBASE_MALUS_SCORE * (NSInteger)game.playerData[player].jumpBaseLevel];
        [game addScore:JUMPBASE_MALUS_SCORE * (NSInteger)game.playerData[player].jumpBaseLevel player:player];
    } else {
        CGRect collidRect = [currentJumpBase collidRect];

        for (JumpBase *fromJumpBase in fromJumpBases) {
            CGRect fromCollidRect = [fromJumpBase collidRect];
            CGPoint from = ccpSub(ccp(fromTouchPos.x, fromCollidRect.origin.y + fromCollidRect.size.height), fromCollidRect.origin);
            CGPoint to = ccpSub(ccp(currentTouchPos.x, collidRect.origin.y + collidRect.size.height), collidRect.origin);
            [fromJumpBase addNextForPlayer:player jumpBase:currentJumpBase fromPos:from toPos:to];
        }
    }
}

- (void)jumpBaseRemoved:(NSNotification *)note {
    JumpBase *jumpBase = [note object];
    if ([fromJumpBases containsObject:jumpBase] && [jumpBase.partsLeft count]) {
        [fromJumpBases removeObject:jumpBase];
        [jumpBase.partsLeft iterateOrRemove:^BOOL(id entry) {
            [fromJumpBases addObject:entry];
            return NO;
        } removeOnYES:NO exit:NO];
    }
}

- (JumpBase *)isInsideFromJB {
    if (currentJumpBase)
        return NO;
   for (JumpBase *fromJumpBase in fromJumpBases) {
        CGRect collidRect = [fromJumpBase collidRect];
        collidRect.origin.x -= 15;
        collidRect.origin.y -= 25;
        collidRect.size.width += 30;
        collidRect.size.height += 45 + [fromJumpBase touchHeightAdded];
        if (CGRectContainsPoint(collidRect, currentTouchPos)) {
            return fromJumpBase;
        }
    }
    return nil;
}

- (void)drawPath {
	NSUInteger pathNodesPerTouch = (sizeof(pathSprite) / sizeof(CCSprite *));
    if ([self isInsideFromJB]) {
        for (int i = 0; i < pathNodesPerTouch; ++i)
            pathSprite[i].visible = NO;
        jumpBaseSprite.visible = NO;
        return;
	}
    CGPoint result;
    double te;
    if (![Physics jumpFrom:fromTouchPos to:currentTouchPos result:&result te:&te])
        return;
    double t = (te / pathNodesPerTouch) / 2;
    CGFloat scaleX = currentTouchPos.x - fromTouchPos.x > 0 ? 1.0 : -1.0;
    for (int i = 0; i < pathNodesPerTouch; ++i) {
        [self drawPathItem:i position:ccp(fromTouchPos.x + result.x * t,
                                        fromTouchPos.y + result.y * t - (NEWTON_G * t * t) / 2)];
        pathSprite[i].scaleX = pathSprite[i].scaleX * scaleX;
        t += te / pathNodesPerTouch;
    }
    jumpBaseSprite.visible = currentJumpBase == nil;
    jumpBaseSprite.position = realJumpBasePos;
    if (isOK)
        jumpBaseSprite.color = ccc3(255, 255, 255);
    else
        jumpBaseSprite.color = ccc3(255, 0, 0);
    jumpBaseSprite.textureRect = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"palette_%d__%d.png", player + 1, realJumpBaseLvl]].rect;
}

- (void)drawPathItem:(NSUInteger)i position:(CGPoint)pos {
    pathSprite[i].color = ccc3(255, 255, 255);
    if (isOK) {
        [game.collidObjects iterateOrRemove:^BOOL(id entry) {
            CollidObject *collidObject = entry;
            CGRect collidRect = CGRectMake(collidObject.sprite.position.x - collidObject.sprite.size.width / 2,
                                           collidObject.sprite.position.y - collidObject.sprite.size.height / 2,
                                           collidObject.sprite.size.width, collidObject.sprite.size.height);
            CGRect bipedeRect = CGRectMake(pathSprite[i].position.x - pathSprite[i].contentSize.width / 4,
                                           pathSprite[i].position.y + pathSprite[i].contentSize.height / 4,
                                           pathSprite[i].contentSize.width / 2,
                                           pathSprite[i].contentSize.height / 2);
            if (CGRectIntersectsRect(collidRect, bipedeRect)) {
                pathSprite[i].color = ccc3(255, 0, 0);
                return YES;
            }
            return NO;
        } removeOnYES:NO exit:YES];
    } else
        pathSprite[i].color = ccc3(255, 0, 0);
	pathSprite[i].position = pos;
	pathSprite[i].visible = YES;
	pathSprite[i].scale = 1.0f + cosf((float)i + -time * 10.0f) / 6.0f;
}

/*- (JumpBase *)findJumpBase:(CGPoint)newPos checkCanHaveNext:(BOOL)checkCanHaveNext {
	JumpBase *closest = [self findNeutralJumpBase:newPos checkCanHaveNext:checkCanHaveNext];
	
	//if (closest == nil)
	//	closest = [self findNeutralJumpBaseFromBipedes:newPos];
	
	return closest;
}*/

- (JumpBase *)findNeutralJumpBase:(CGPoint)pos checkCanHaveNext:(BOOL)checkCanHaveNext limitDist:(BOOL)limitDist {
	__block JumpBase *closest = nil;
	__block CGFloat diff = 0;
	[game.jumpBases iterateOrRemove:^BOOL(id entry) {
		JumpBase *jumpBase = entry;
		if (!jumpBase.active ||
			[fromJumpBases containsObject:jumpBase] ||
			(checkCanHaveNext && !jumpBase.canHaveNext) ||
			(jumpBase.player != player && jumpBase.player != NEUTRAL_PLAYER))
			return NO;
		CGRect collidRect = [jumpBase collidRect];
        CGPoint rectDiffPoint = CGPointMake((pos.x < collidRect.origin.x ? collidRect.origin.x : (pos.x > collidRect.origin.x + collidRect.size.width ? collidRect.origin.x + collidRect.size.width : pos.x)), (pos.y < collidRect.origin.y ? collidRect.origin.y : (pos.y > collidRect.origin.y + collidRect.size.height ? collidRect.origin.y + collidRect.size.height : pos.y)));
		CGFloat diffX = fabsf(rectDiffPoint.x - pos.x);
		CGFloat diffY = fabsf(rectDiffPoint.y - pos.y);
		CGFloat newDiff = sqrtf(powf(diffX, 2) + powf(diffY, 2));
        collidRect = CGRectMake(collidRect.origin.x - 15,
                                collidRect.origin.y - 25,
                                collidRect.size.width + 30,
                                collidRect.size.height + 45 + [jumpBase touchHeightAdded]);
		if ((!limitDist || CGRectContainsPoint(collidRect, pos)) && (closest == nil || (newDiff < diff))) {
			closest = jumpBase;
			diff = newDiff;
			return NO;
		}
		return NO;
	} removeOnYES:NO exit:NO];
	return closest;
}

/*- (JumpBase *)findNeutralJumpBaseFromBipedes:(CGPoint)pos {
	__block JumpBase *result = nil;
    __block CGFloat diff = 0;
    BOOL(^callback)(id entry) = ^(id entry){
		Bipede *bipede = entry;
		CGRect bipedeRect = CGRectMake(bipede.sprite.position.x - bipede.sprite.size.width / 2 - 15.0f,
									   bipede.sprite.position.y - 15.0f, bipede.sprite.size.width + 30.0f,
									   bipede.sprite.size.height + 30.0f);
		bipedeRect.origin.x = bipedeRect.origin.x < 0 ? 0 : bipedeRect.origin.x;
		bipedeRect.origin.y = bipedeRect.origin.y < 0 ? 0 : bipedeRect.origin.y;
        if (!(bipede.currentJumpBase != nil && bipede.currentJumpBase.canHaveNext && [fromJumpBases containsObject:bipede.currentJumpBase] &&
              CGRectContainsPoint(bipedeRect, pos)))
            return NO;
		CGFloat diffX = fabsf((bipedeRect.origin.x + bipedeRect.size.width / 2) - pos.x);
        CGFloat diffY = fabsf((bipedeRect.origin.y + bipedeRect.size.height / 2) - pos.y);
		CGFloat newDiff = sqrtf(powf(diffX, 2) + powf(diffY, 2));
		if (result == nil || newDiff < diff) {
			result = bipede.currentJumpBase;
            diff = newDiff;
			return NO;
		}
		return NO;
	};
	[game.playerData[player].bipedes iterateOrRemove:callback removeOnYES:NO exit:NO];
	[game.pnjs iterateOrRemove:callback removeOnYES:NO exit:NO];
	return result;
}*/

- (void)avoidOverLap {
    CGSize minPlateformeSize = [JumpPlateforme sizeForLevel:1];
    CGSize plateformeSize = [JumpPlateforme sizeForLevel:game.playerData[player].jumpBaseLevel];
    CGRect result = CGRectMake(currentTouchPos.x - plateformeSize.width / 2, currentTouchPos.y - plateformeSize.height / 2, plateformeSize.width, plateformeSize.height);
    if (![self bestRectFit:&result pos:currentTouchPos minimumSize:minPlateformeSize]) {
        isOK = NO;
        realJumpBasePos = currentTouchPos;
        realJumpBaseLvl = game.playerData[player].jumpBaseLevel;
    } else {
        isOK = YES;
        realJumpBaseLvl = MIN(floorf(result.size.width / minPlateformeSize.width), game.playerData[player].jumpBaseLevel);
        plateformeSize = [JumpPlateforme sizeForLevel:realJumpBaseLvl];
        CGRect touchRect = CGRectMake(currentTouchPos.x - plateformeSize.width / 2, currentTouchPos.y - plateformeSize.height / 2, plateformeSize.width, plateformeSize.height);
        if (touchRect.size.width > result.size.width)
            touchRect.size.width = result.size.width;
        if (touchRect.size.height > result.size.height)
            touchRect.size.height = result.size.height;
        
        if (touchRect.origin.x < result.origin.x)
            touchRect.origin.x = result.origin.x;
        if (touchRect.origin.x + touchRect.size.width > result.origin.x + result.size.width)
            touchRect.origin.x += (result.origin.x + result.size.width) - (touchRect.origin.x + touchRect.size.width);
        
        if (touchRect.origin.y < result.origin.y)
            touchRect.origin.y = result.origin.y;
        if (touchRect.origin.y + touchRect.size.height > result.origin.y + result.size.height)
            touchRect.origin.y += (result.origin.y + result.size.height) - (touchRect.origin.y + touchRect.size.height);
        realJumpBasePos = ccp(touchRect.origin.x + touchRect.size.width / 2, touchRect.origin.y + touchRect.size.height);
        
    }
}

- (BOOL)bestRectFit:(CGRect *)result pos:(CGPoint)pos minimumSize:(CGSize)minSize {
    __block BOOL failed = NO;
    CGSize desiredSize = (*result).size;
    (*result) = CGRectMake(pos.x - desiredSize.width, pos.y - desiredSize.height, desiredSize.width * 2, desiredSize.height * 2);
	void(^callBack)(CGRect avoidRect) = ^(CGRect avoidRect) {
        CGRect rect1;
        CGRect rect2;
		if (avoidRect.origin.x + avoidRect.size.width < pos.x) {
            CGPoint origin1 = CGPointMake(avoidRect.origin.x + avoidRect.size.width, (*result).origin.y);
            CGSize size1 = CGSizeMake((*result).size.width - (origin1.x - (*result).origin.x), (*result).size.height);
            rect1.origin = origin1;
            rect1.size = size1;
        } else {
            CGPoint origin1 = CGPointMake((*result).origin.x, (*result).origin.y);
            CGSize size1 = CGSizeMake(avoidRect.origin.x - origin1.x, (*result).size.height);
            rect1.origin = origin1;
            rect1.size = size1;
        }
        
        if (avoidRect.origin.y + avoidRect.size.height < pos.y) {
            CGPoint origin2 = CGPointMake((*result).origin.x, avoidRect.origin.y + avoidRect.size.height);
            CGSize size2 = CGSizeMake((*result).size.width, (*result).size.height - (origin2.y - (*result).origin.y));
            rect2.origin = origin2;
            rect2.size = size2;
        } else {
            CGPoint origin2 = CGPointMake((*result).origin.x, (*result).origin.y);
            CGSize size2 = CGSizeMake((*result).size.width, avoidRect.origin.y - origin2.y);
            rect2.origin = origin2;
            rect2.size = size2;
        }
        
        if ([self rectHeuristic:rect1 pos:pos desiredSize:desiredSize minimumSize:minSize] > [self rectHeuristic:rect2 pos:pos desiredSize:desiredSize minimumSize:minSize])
            (*result) = rect1;
        else
            (*result) = rect2;
	};
    
    void(^processRect)(CGRect collidRect) = ^(CGRect collidRect) {
        if (CGRectIntersectsRect(collidRect, (*result))) {
            callBack(collidRect);
        }
    };
    
    BOOL(^processGameElement)(BaseGameElement *gameElement) = ^(BaseGameElement *gameElement){
        CGRect collidRect = [gameElement collidRect];
        if (gameElement.player != NEUTRAL_PLAYER && gameElement.player != player)
            return NO;
        if (CGRectContainsPoint(collidRect, pos)) {
            failed = YES;
            return YES;
        }
        processRect(collidRect);
        return NO;
    };
    
    [game.collidObjects iterateOrRemove:processGameElement removeOnYES:NO exit:YES];
    if (!failed)
        [game.jumpBases iterateOrRemove:processGameElement removeOnYES:NO exit:YES];
    return !failed && result->size.width >= minSize.width && result->size.height >= minSize.height;
}

- (NSUInteger)rectHeuristic:(CGRect)rect pos:(CGPoint)pos desiredSize:(CGSize)desiredSize minimumSize:(CGSize)minSize {
    if (!CGRectContainsPoint(rect, pos) || rect.size.width < 0 || rect.size.height < 0)
        return 0;
    NSUInteger result = 0;
    CGFloat size = rect.size.width * rect.size.height;
    
    result += size;
    
    if (rect.size.width >= desiredSize.width && rect.size.height >= desiredSize.height)
        result += 100;
    else if (rect.size.width >= minSize.width && rect.size.height >= minSize.height)
        result += 50;
    
    return result;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [fromJumpBases release];
    for (int i = 0; i < sizeof(pathSprite) / sizeof(CCSprite *); ++i)
        [pathSprite[i] removeFromParentAndCleanup:YES];
    [jumpBaseSprite removeFromParentAndCleanup:YES];
    [currentJumpBase release];
	[super dealloc];
}

@end
