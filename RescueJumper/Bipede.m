//
//  MovingEntity.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

#import "Physics.h"

#import "Actioner.h"

#import "SimpleAudioEngine.h"

#import "Display.h"
#import "Screen.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"
#import "ParticleDisplayObject.h"
#import "BubbledTextDisplayObject.h"

#import "Game.h"
#import "PlayerData.h"

#import "Scores.h"

#import "MBDACenter.h"
#import "ProxyAim.h"

#import "Missile.h"

#import "Bipede.h"
#import "BipedeBonus.h"
#import "MissileDeath.h"
#import "HumanMovement.h"
#import "NeutralMovement.h"
#import "ZombieMovement.h"

#import "JumpBase.h"

#import "Ship.h"

@implementation Bipede

@synthesize saved;
@synthesize dead;

@synthesize player;
@synthesize currentJumpBase;

@synthesize picker;

@synthesize Vx;
@synthesize Vy;

@synthesize sprite;

@synthesize actioner;

@synthesize converting;

@synthesize bonus;

@synthesize movement;

- (id)initWithJumpBase:(JumpBase *)jumpBase player:(NSInteger)_player game:(Game *)_game {
	
	self = [super init];
	if (self) {
		game = _game;
		player = _player;

		saved = NO;
		dead = NO;
		converting = NO;
        particles = nil;

        switch (player) {
            case NEUTRAL_PLAYER:
                self.movement = [self getNeutralMovement];
                break;
            case ZOMBIE_PLAYER:
                self.movement = [self getZombieMovement];
                particles = [[ParticleDisplayObject alloc] initParticleNode:@"odeurzombie.plist" scale:1.0];
                particles.position = ccp(0, 0);
                [[Display sharedDisplay] addDisplayObject:particles onNode:BACK z:0];
                
                break;
            default:
                self.movement = [self getNormalMovement];
                break;
        }

		sprite = [[AnimatedDisplayObject alloc] initAnimatedNode:[NSString stringWithFormat:@"stand%d_1.png", player + 1] defaultScale:1.0f anchor:ccp(0.5, 0)];
		[self initAnims];

		sprite.scaleX = rand() % 2 ? -1 : 1;
        if (jumpBase) {
            CGRect collidRect = [jumpBase collidRect];
            sprite.position = ccp(collidRect.origin.x + rand() % (int)collidRect.size.width,
                                  collidRect.origin.y + collidRect.size.height);
        }
		[[Display sharedDisplay] addDisplayObject:sprite onNode:[self getNode] z:-1];

		Vx = 0;
		Vy = 0;

		if (player == PLAYER1 || player == PLAYER2)
			sprite.mainScreen = player;

		self.currentJumpBase = jumpBase;

		actioner = [[Actioner alloc] init];
		[movement initActions];
		
	}
	return self;
}

- (void)initAnims {
	[movement initAnims];
}

- (void)update:(ccTime)dt {
	[movement update];
	if (saved)
		return;
	[actioner update:dt];
	if (!currentJumpBase)
		Vy -= NEWTON_G * dt;
	sprite.position = ccp(sprite.position.x + Vx * dt + (currentJumpBase ? currentJumpBase.Vx * dt : 0),
						sprite.position.y + Vy * dt + (currentJumpBase ? currentJumpBase.Vy * dt : 0));
	if (particles) {
		particles.sourcePosition = ccpAdd(sprite.position, ccp(0, sprite.size.height));
    }
	
	if (message) {
		message.position = ccpAdd(sprite.position, ccp(0, sprite.size.height));
		message.scale += (messageScale - message.scale) * dt * 6;
		message.scale = message.scale > messageScale ? messageScale : message.scale;
		messageTime -= dt;
		if (messageTime <= 0)
			[self displayMessage:nil scale:0];
	}
}

- (void)displayMessage:(NSString *)_message scale:(CGFloat)scale {
	[self displayMessage:_message scale:scale color:ccc3(255, 255, 255)];
}

- (void)displayMessage:(NSString *)_message scale:(CGFloat)scale color:(ccColor3B)color {
	if (message) {
		[message release];
		message = nil;
	}
	
	if (_message) {
		message = [[BubbledTextDisplayObject alloc] initWithFont:@"burgley19b.fnt" anchor:ccp(0.9f, -0.35f) text:_message];
		message.color = color;
		message.mainScreen = player < game.nPlayer ? player : -1;
		message.scale = 0.0f;
		messageScale = scale;
		[[Display sharedDisplay] addDisplayObject:message onNode:FRONT z:100000];
		messageTime = 3.0f;
	}
}

- (BOOL)isDisplayingMessage {
    return message != nil;
}

- (void)convertToPlayer:(NSUInteger)_player {
    
    static NSDictionary *particleRingDict = nil;
    NSUInteger lastPlayer = player;
    
	if (player == _player)
		return;
	converting = NO;
	if (_player < game.nPlayer) {
		sprite.mainScreen = _player;
		self.movement = nil;
        player = _player;
		self.movement = [self getNormalMovement];
		[game.playerData[player] addStat:STAT_CONVERTED_HUMAN n:1 pts:CONVERTED_SCORE];
		[game addScore:CONVERTED_SCORE player:player pos:ccp(sprite.position.x, sprite.position.y + sprite.size.height)];
        
        if (!particleRingDict)
            particleRingDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"humanring" ofType:@"plist"]] retain];
		CCParticleSystemQuad *particleRing = [[CCParticleSystemQuad alloc] initWithDictionary:particleRingDict];
		particleRing.position = ccp(sprite.position.x, sprite.position.y + 20);
		particleRing.autoRemoveOnFinish = YES;
		[[Display sharedDisplay].screens[player].backNode addChild:particleRing];
        [particleRing release];
	} else if (_player == NEUTRAL_PLAYER) {
		self.movement = nil;
        player = _player;
		self.movement = [self getNeutralMovement];
		sprite.mainScreen = -1;
	} else if (_player == ZOMBIE_PLAYER) {
		[movement onKilled];
        if (player < game.nPlayer)
            [game.playerData[player] addStat:STAT_INFECTED n:1 pts:0];
		self.movement = [self getZombieMovement];
        player = _player;
		sprite.mainScreen = -1;
		[[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"zombie%d.wav", (rand() % 3) + 1]];
        particles = [[ParticleDisplayObject alloc] initParticleNode:@"odeurzombie.plist" scale:1.0];
        particles.position = ccp(0, 0);
        [[Display sharedDisplay] addDisplayObject:particles onNode:BACK z:0];
	}
	[game moveBipede:self from:lastPlayer to:_player];
    [bonus bipedePlayerChanged:lastPlayer to:_player];
	converting = NO;
	[movement initActions];
	bonus.sprite.mainScreen = sprite.mainScreen;
	[sprite reset];
	[self initAnims];
	if (Vx)
		[self.movement run:Vx > 0];
}

- (void)setCurrentJumpBase:(JumpBase *)_currentJumpBase {
	[currentJumpBase.onBoard iterateOrRemove:^BOOL(id entry) {
		return entry == self;
	} removeOnYES:YES exit:YES];
	[currentJumpBase release];

	currentJumpBase = [_currentJumpBase retain];
	if (currentJumpBase != nil) {
		if (player < game.nPlayer && [currentJumpBase type] != JUMPBASE_SHIP)
			[game.playerData[player] setBipedeActive:self active:YES];
		[currentJumpBase.onBoard addEntry:self];
		CGRect collidRect = [currentJumpBase collidRect];
		sprite.position = ccp(sprite.position.x, collidRect.origin.y + collidRect.size.height);
	}
}

- (void)currentJumpBaseDeleted {
	[currentJumpBase release];
	currentJumpBase = nil;
}

- (CGFloat)getWaitingTime {
	if (player == ZOMBIE_PLAYER)
		return 1.2;
	if (bonus != nil)
		return 0.6;
	return 0.9;
}

- (void)sizeChanged {
	if (bonus != nil)
		[bonus bipedeSizeChanged];
}

- (NSUInteger)getNode {
	return BIPEDE;
}

- (NSObject<Movement> *)getNormalMovement {
	return [[[HumanMovement alloc] initWithBipede:self game:game] autorelease];
}

- (NSObject<Movement> *)getNeutralMovement {
	return [[[NeutralMovement alloc] initWithBipede:self game:game] autorelease];
}

- (NSObject<Movement> *)getZombieMovement {
	return [[[ZombieMovement alloc] initWithBipede:self game:game] autorelease];
}

- (void)dealloc {
	self.bonus = nil;
	self.currentJumpBase = nil;
	self.movement = nil;
	[actioner release];
	[sprite release];
	[particles stop];
	[particles release];
    [self displayMessage:nil scale:0];
	[super dealloc];
}

@end
