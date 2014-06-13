//
//  CoinBonus.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CoinBonus.h"

#import "cocos2d.h"

#import "Game.h"
#import "Bipede.h"
#import "AnimatedDisplayObject.h"
#import "PlayerData.h"
#import "Display.h"
#import "Screen.h"

#import "Scores.h"

@implementation CoinBonus

- (id)initWithGame:(Game *)_game value:(CGFloat)_value {
	
	if (self = [super initWithGame:_game]) {
        value = _value;

		AnimatedDisplayObject *_sprite = [[AnimatedDisplayObject alloc] initAnimatedNode:@"piece_1.png" defaultScale:1.0f anchor:ccp(0.5f, 0.5f)];
		[_sprite initAnim:@"roll_coin" n:13 delay:0.1f animPrefix:@"piece_"];
		[_sprite setAnim:@"roll_coin" repeat:YES];
		sprite = _sprite;
		size = sprite.size;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BONUS z:0];
		
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	[super update:dt];
}

- (BOOL)execute:(Bipede *)bipede dt:(ccTime)dt {

    static NSDictionary *particleDict = nil;
    
	if (bipede.player >= game.nPlayer)
		return NO;
    
    if (!particleDict)
        particleDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"money" ofType:@"plist"]] retain];
    
	sprite.visible = NO;
	toDelete = YES;
    [game.playerData[bipede.player] addStat:STAT_COINS n:value pts:value];
    [[SimpleAudioEngine sharedEngine] playEffect:@"bonus.wav"];
	CCParticleSystemQuad *particles = [[CCParticleSystemQuad alloc] initWithDictionary:particleDict];
	particles.autoRemoveOnFinish = YES;
	particles.position = sprite.position;
	[[Display sharedDisplay].screens[bipede.player].backNode addChild:particles];
    [particles release];
    
	return YES;
}

@end
