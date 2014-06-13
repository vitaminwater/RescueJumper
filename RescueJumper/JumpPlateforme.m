//
//  JumpBase.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

#import "Actioner.h"
#import "Fall.h"

#import "JumpPlateforme.h"

#import "Game.h"
#import "PlayerData.h"

#import "Display.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"

#import "ChainList.h"

#import "PartsManager.h"

#import "Bipede.h"

@interface JumpPlateforme()

- (void)explode:(CGPoint)pos;

@end

@implementation JumpPlateforme

@synthesize level;

- (id)initWithPlayer:(NSUInteger)_player level:(NSUInteger)_level game:(Game *)_game {

	if (self = [super initWithGame:_game]) {

		player = _player;
		level = _level;

		capacityMax = _level * CAPACITY_PER_LEVEL;

		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:[NSString stringWithFormat:@"palette_%d__%d.png", player + 1, _level] anchor:ccp(0.5, 1.0) isSpriteFrame:YES];
		sprite = _sprite;
		sprite.mainScreen = player;
		size = sprite.size;
		
		noLink = [[StaticDisplayObject alloc] initSprite:@"dead-end.png" anchor:ccp(0.5f, 0.0f) isSpriteFrame:YES];
		noLink.position = ccp(sprite.size.width, sprite.size.height);
		noLink.opacity = 0;
		[sprite addSubDisplayObject:noLink];

		partsManager = [[PartsManager alloc] initWithNParts:_level partSize:size.width / _level partsHP:4];

		[[Display sharedDisplay] addDisplayObject:sprite onNode:BLOCK_BACK z:0];

		canHaveNext = YES;
		isCabled = YES;
        isDeletable = YES;
        
        self.color = rand() % 5;
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
		
	}
	return self;
}

- (void)update:(ccTime)dt {
	[super update:dt];
    if (timeUnused > 10.0f) {
        self.active = NO;
        Vy = (400.0f - Vy) / 10;
        self.sprite.opacity -= (self.sprite.opacity < 10.0f ? self.sprite.opacity : 10.0f);
        if (!self.sprite.opacity)
            self.toDelete = YES;
    }
	if (active && canHaveNext) {
		if (!linkedTo) {
			timeUnlinked+=dt;
			sprite.opacity = 120.0f * (cosf(lifeTime * 20.0f) + 1.0f) / 2.0f + 135.0f;
			if (timeUnlinked > 4.0f)
				noLink.opacity = 255 - sprite.opacity + 135;
		} else {
			timeUnlinked = 0;
			sprite.opacity = 255;
			noLink.opacity = (NSInteger)noLink.opacity - 15 <= 0 ? 0 : noLink.opacity - 15;
		}
	}
    
    if (fabs(Vy) > 0.1) {
        CGRect collidRect = [self collidRect];
        collidRect.origin.x += Vx * dt;
        collidRect.origin.y += Vy * dt;
        
        [game.jumpBases iterateOrRemove:^BOOL(id entry) {
            JumpBase *current = entry;
            if (current == self || !current.active || current.type == JUMPBASE_SHIP || current.toDelete)
                return NO;
            CGRect currentRect = [current collidRect];
            if (CGRectIntersectsRect(collidRect, currentRect)) {
                [self blockedWall:(currentRect.origin.x + currentRect.size.width / 2.0f) - (collidRect.origin.x + collidRect.size.width / 2.0f) force:10.0f];
                current.timeUnused = 0;
                return YES;
            }
            return NO;
        } removeOnYES:NO exit:YES];
    }
}

- (void)bipedeAdded:(Bipede *)bipede {
	[super bipedeAdded:bipede];
}

- (void)bipedeRemoved:(Bipede *)bipede {
	[super bipedeRemoved:bipede];
}

- (void)blockedWall:(NSInteger)hitPoint force:(CGFloat)force {
	CGRect currentRect = [self collidRect];
	hitPoint = (hitPoint < 0 ? 0 : (hitPoint > size.width ? size.width : hitPoint));
	self.toDelete = [partsManager hit:hitPoint force:force resultingBlock:^(NSUInteger position, NSUInteger _size) {
		JumpPlateforme *newJumpPlateforme = [[JumpPlateforme alloc] initWithPlayer:player level:_size game:game];
		newJumpPlateforme.sprite.position = CGPointMake(currentRect.origin.x + position * partsManager->partSize + newJumpPlateforme.size.width / 2, self.sprite.position.y);
		newJumpPlateforme.active = YES;
		//CGRect newRect = [newJumpPlateforme collidRect];
		
		for (JBlink *current = linkedTo; current; current = current->next) {
            CGPoint from = CGPointMake(current->from.x - position * partsManager->partSize, current->from.y);
            from.x = from.x < 0 ? 0 : (from.x > partsManager->partSize * _size ? partsManager->partSize * _size : from.x);
            CGPoint to = CGPointMake(current->to.x - position * partsManager->partSize, current->to.y);
            to.x = to.x < 0 ? 0 : (to.x > partsManager->partSize * _size ? partsManager->partSize * _size : to.x);
			[newJumpPlateforme addNextForPlayer:current->player jumpBase:current->base fromPos:from toPos:to];
		}
		
		newJumpPlateforme.lifeTime = lifeTime;
		
		[game.jumpBases addEntry:newJumpPlateforme];
		[partsLeft addEntry:newJumpPlateforme];
		[newJumpPlateforme release];
		
	}];
	if (self.toDelete)
        [self explode:CGPointMake(currentRect.origin.x + hitPoint, currentRect.origin.y + currentRect.size.height / 2)];
}

- (void)explode:(CGPoint)pos {
    static NSDictionary *explodeDict = nil;
    
    if (!explodeDict)
        explodeDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"metal_explode" ofType:@"plist"]] retain];
    [[Display sharedDisplay] spawnParticleDict:explodeDict pos:pos];
    [[Display sharedDisplay] shakeScreens:10];
    
    if (player < game.nPlayer) {
        [game.playerData[player] addStat:STAT_N_BROKEN_PLATEFORME n:1 pts:BROKEN_PLATEFORMES];
        [game addScore:BROKEN_PLATEFORMES player:player pos:sprite.position];
    }
    
    self.active = NO;
    [onBoard iterateOrRemove:^BOOL(id entry) {
        Bipede *bipede = entry;
        [bipede currentJumpBaseDeleted];
        bipede.Vx = (rand() % 2 ? -1 : 1) * 50;
        bipede.Vy = 300 + (rand() % 40);
        
        Fall *fall = [[Fall alloc] initWithBipede:bipede game:game];
        [[bipede actioner] setCurrentAction:fall interrupted:YES];
        [fall release];
        return YES;
    } removeOnYES:YES exit:NO];
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - sprite.size.width / 2,
					  sprite.position.y - sprite.size.height,
					  sprite.size.width, sprite.size.height);
}

- (void)setColor:(NSUInteger)_color {
    super.color = _color;
    sprite.borderColor = color_array[color];
}

- (NSUInteger)type {
    return JUMPBASE_PLATEFORME;
}

- (void)dummy:(id)sender {}

+ (CGSize)sizeForLevel:(NSUInteger)_level {
    return CGSizeMake(50.0f * _level, 24);
}

- (void)dealloc {
	[partsManager release];
    [noLink release];
	[super dealloc];
}

@end
