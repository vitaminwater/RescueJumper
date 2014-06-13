//
//  HangAround.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HangAround.h"

#import "Bipede.h"

#import "JumpBase.h"

#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"
#import "DisplayObject.h"
#import "Display.h"

#import "Game.h"

@implementation HangAround

- (BOOL)canTrigger
{
	return bipede.currentJumpBase != nil;
}

- (int)getPriority
{
	return 0;
}

- (BOOL)update:(float)dt
{
	if (bipede.currentJumpBase == nil)
		return NO;
	CGRect collidRect = [bipede.currentJumpBase collidRect];
	if ((bipede.Vx > 0 && bipede.sprite.position.x + bipede.sprite.size.width / 4 > collidRect.origin.x + collidRect.size.width) ||
		(bipede.Vx < 0 && (bipede.sprite.position.x - bipede.sprite.size.width / 4 < collidRect.origin.x))) {
		bipede.Vx = -bipede.Vx;
		bipede.sprite.scaleX = bipede.Vx > 0 ? 1 : -1;
	}
	timeToNextAction -= dt;
	if (timeToNextAction <= 0 || (bipede.converting && !standing))
		[self newChoice];
	return YES;
}

- (void)newChoice {
	if (bipede.currentJumpBase.Vy < 0) {
		[bipede.movement fear:rand() % 2];
		[bipede displayMessage:@"!" scale:2.0f];
		standing = NO;
	} else if (!bipede.converting && rand() % 2) {
		[bipede.movement walk:rand() % 2];
		standing = NO;
		[bipede displayMessage:nil scale:0];
	} else if (!standing) {
		if (bipede.player != ZOMBIE_PLAYER && ![bipede.currentJumpBase linksTo] && !(rand() % 3))
			[bipede displayMessage:@"Help !" scale:1.0f];
		[bipede.movement stand:(bipede.converting ? bipede.movement.right : rand() % 2)];
		standing = YES;
	}
	timeToNextAction = rand() % 2 + 1;
}

- (void)end:(BOOL)interrupted {
	[bipede displayMessage:nil scale:0];
}

@end
