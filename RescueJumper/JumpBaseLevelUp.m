//
//  JumpBaseLevelUp.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "JumpBaseLevelUp.h"

#import "cocos2d.h"

#import "AnimatedDisplayObject.h"
#import "PlayerData.h"
#import "Bipede.h"
#import "Game.h"
#import "Display.h"

@implementation JumpBaseLevelUp

- (id)initWithGame:(Game *)_game {

	if (self = [super initWithGame:_game]) {
		
		AnimatedDisplayObject *_sprite = [[AnimatedDisplayObject alloc] initAnimatedNode:@"plateforme_1.png" defaultScale:0.7 anchor:ccp(0.5, 0.5)];
		[_sprite initAnim:@"normal" n:2 delay:0.2 animPrefix:@"plateforme_"];
		[_sprite setAnim:@"normal" repeat:YES];
		sprite = _sprite;
		size = sprite.size;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BONUS z:0];
		
	}
	return self;

}

- (BOOL)execute:(Bipede *)bipede dt:(ccTime)dt {
	if (bipede.player >= game.nPlayer)
		return NO;
	sprite.visible = NO;
	game.playerData[bipede.player].jumpBaseLevel++;
	game.playerData[bipede.player].maxJumpDistance += 40;
	[[SimpleAudioEngine sharedEngine] playEffect:@"bonus.wav"];
	return YES;
}

@end
