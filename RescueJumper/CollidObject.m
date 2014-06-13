//
//  CollidObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

#import "SimpleAudioEngine.h"

#import "CollidObject.h"

#import "ProxyAim.h"

#import "Game.h"
#import "PlayerData.h"

#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"
#import "Display.h"

#import "Bipede.h"
#import "Fall.h"
#import "SwallowByBlackHole.h"

#import "JumpBase.h"

#import "PartsManager.h"

#import "Missile.h"

@implementation CollidObject

@synthesize Vx;
@synthesize Vy;
@synthesize sprite;
@synthesize position;
@synthesize breakable;
@synthesize size;

- (id)initWithGame:(Game *)_game size:(NSUInteger)_size mvt:(BOOL)_mvt breakable:(BOOL)_breakable from:(CGPoint)_from to:(CGPoint)_to {
	
	if (self = [super init]) {
		game = _game;
		Vx = 0;
		Vy = 0;
		mvt = _mvt;
		breakable = _breakable;
		size = _size;
		reverse = NO;
		from = _from;
		to = _to;
		if (mvt) {
			Vx = (to.x - from.x);
			Vy = (to.y - from.y);
		}
		sprite = [[StaticDisplayObject alloc] initSprite:[NSString stringWithFormat:@"%@wall_%d.png", (breakable ? @"rock" : @"metal"), size] anchor:ccp(0.5, 0.5) isSpriteFrame:YES];
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BLOCK_BACK z:0];
        
        partsManager = [[PartsManager alloc] initWithNParts:size partSize:sprite.size.height / size partsHP:3];
        
        if (_breakable) {
            aimObject = [[ProxyAim alloc] initWithDelegate:self];
            [[MBDACenter sharedMBDACenter].aims addEntry:aimObject];
            [aimObject release];
        }
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    CGRect selfRect = CGRectMake(sprite.position.x - sprite.size.width / 2 + Vx * dt,
                                 sprite.position.y - sprite.size.height / 2 + Vy * dt,
                                 sprite.size.width, sprite.size.height);
    
	totalTime += dt;
	[game.pnjs iterateOrRemove:^BOOL(id entry) {
		Bipede *bipede = entry;
        [self checkBipede:bipede collidRect:selfRect delta:dt];
		return !sprite.visible;
	} removeOnYES:NO exit:YES];
    if (!sprite.visible)
        return;
	for (int i = 0; i < game.nPlayer; ++i) {
		[game.playerData[i].bipedes iterateOrRemove:^BOOL(id entry) {
			Bipede *bipede = entry;
            [self checkBipede:bipede collidRect:selfRect delta:dt];
			return !sprite.visible;
		} removeOnYES:NO exit:YES];
        if (!sprite.visible)
            return;
	}
	if (mvt) {
		CGPoint limit = ccpAdd(reverse ? from : to, position);
		limit.y = (limit.y > [Display sharedDisplay].size.height - 36 ? [Display sharedDisplay].size.height - 36 : limit.y);
		if (CGRectContainsPoint(selfRect, limit)) {
			[self invertDir];
		} else {
			[game.jumpBases iterateOrRemove:^BOOL(id entry) {
				JumpBase *jumpBase = entry;
				if (!jumpBase.active)
					return NO;
				CGRect jumpBaseRect = [jumpBase collidRect];
				if (CGRectIntersectsRect(selfRect, jumpBaseRect)) {
					[self invertDir];
					[jumpBase blockedWall:(selfRect.origin.x + selfRect.size.width / 2) - jumpBaseRect.origin.x force:1.0f];
					return YES;
				}
				return NO;
			} removeOnYES:NO exit:YES];
		}
	}
	sprite.position = ccpAdd(sprite.position, ccp(Vx * dt, Vy * dt));
}

- (void)invertDir {
	reverse = !reverse;
	if (!reverse) {
		Vx = (to.x - from.x) / 5;
		Vy = (to.y - from.y) / 5;
	} else {
		Vx = (from.x - to.x) / 5;
		Vy = (from.y - to.y) / 5;
	}
}

- (BOOL)checkBipede:(Bipede *)bipede collidRect:(CGRect)collidRect delta:(ccTime)dt {
	if (bipede.currentJumpBase || bipede.dead)
		return NO;
    if ((bipede.Vx > 0) != (sprite.position.x - bipede.sprite.position.x > 0))
        return NO;
	CGRect bipedeRect = CGRectMake(bipede.sprite.position.x - bipede.sprite.size.width / 4 + bipede.Vx * dt,
								   bipede.sprite.position.y + bipede.sprite.size.height / 4 + bipede.Vy * dt,
								   bipede.sprite.size.width / 2,
								   bipede.sprite.size.height / 2);
	if (CGRectIntersectsRect(bipedeRect,
							 collidRect)) {
								 if (![bipede.actioner.currentAction isKindOfClass:[SwallowByBlackHole class]]) {
									 [[SimpleAudioEngine sharedEngine] playEffect:!breakable ? @"hitMetalWall.wav" : @"hitRockWall.wav"];
									 if (breakable && [self hit:(bipede.sprite.position.y + bipede.sprite.size.height / 2) - collidRect.origin.y force:1.0f]) {
                                         if (bipede.player < game.nPlayer) {
                                             [game.playerData[bipede.player] addStat:STAT_N_BROKEN_WALL n:1 pts:BROCKEN_WALL_SCORE];
                                             [game addScore:BROCKEN_WALL_SCORE player:bipede.player pos:ccpAdd(bipede.sprite.position, ccp(0, bipede.sprite.size.height / 2.0f))];
                                         }
                                     } else {
										 bipede.Vx = -bipede.Vx / 3;
										 if (![bipede.actioner.currentAction isKindOfClass:[Fall class]]) {
											 Fall *fall = [[Fall alloc] initWithBipede:bipede game:game];
											 [bipede.actioner setCurrentAction:fall interrupted:YES];
											 [fall release];
										 }
									 }
										 
								 }
							 }
	return NO;
}

- (void)setPosition:(CGPoint)_position {
	position = _position;
	sprite.position = position;
}

- (BOOL)hit:(CGFloat)height force:(CGFloat)force {
    static NSDictionary *explodeDict = nil;
    
    height = (height < 0 ? 0 : (height > sprite.size.height ? sprite.size.height : height));
    sprite.visible = ![partsManager hit:height force:force resultingBlock:^(NSUInteger _position, NSUInteger _size) {
        CollidObject *newCollidObject = [[CollidObject alloc] initWithGame:game size:_size mvt:mvt breakable:YES from:from to:to];
        newCollidObject.position = ccp(sprite.position.x, (sprite.position.y - sprite.size.height / 2) + _position * partsManager->partSize + newCollidObject.sprite.size.height / 2);
        [game.collidObjects addEntry:newCollidObject];
        [newCollidObject release];
    }];
	
	if (!sprite.visible) {
        if (!explodeDict)
            explodeDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rock_explode" ofType:@"plist"]] retain];
		[[Display sharedDisplay] spawnParticleDict:explodeDict pos:CGPointMake(sprite.position.x + sprite.size.width / 2, sprite.position.y + height - sprite.size.height / 2)];
        [[Display sharedDisplay] shakeScreens:10];
        return YES;
    }
    return NO;
}

- (CGPoint)aimPosition {
    return CGPointMake(self.sprite.position.x, self.sprite.position.y - self.sprite.size.height / 2 + (rand() % (NSInteger)self.sprite.size.height));
}

- (BOOL)hitAndRemove:(Missile *)missile {
    [self hit:missile.sprite.position.y - (self.sprite.position.y - self.sprite.size.height / 2) force:4.0f];
    if (missile.player < game.nPlayer) {
        [game.playerData[missile.player] addStat:STAT_N_BROKEN_WALL n:1 pts:BROCKEN_WALL_SCORE];
        [game addScore:BROCKEN_WALL_SCORE player:missile.player pos:missile.sprite.position];
    }
    return YES;
}

- (NSInteger)player {
    return NEUTRAL_PLAYER;
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - sprite.size.width / 2,
					  sprite.position.y - sprite.size.height / 2,
					  sprite.size.width, sprite.size.height);
}

- (void)dealloc {
	[sprite release];
    [partsManager release];
    [[MBDACenter sharedMBDACenter].aims iterateOrRemove:^BOOL(id entry) {
        return entry == aimObject;
    } removeOnYES:YES exit:YES];
	[super dealloc];
}

@end
