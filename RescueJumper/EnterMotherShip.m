//
//  EnterMotherShip.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "EnterMotherShip.h"

#import "Bipede.h"
#import "AnimatedDisplayObject.h"
#import "JumpBase.h"
#import "MotherShip.h"

#import "Game.h"
#import "PlayerData.h"

#import "Display.h"
#import "Screen.h"

@implementation EnterMotherShip

- (BOOL)canTrigger {
	if (bipede.currentJumpBase != nil && [bipede.currentJumpBase type] == JUMPBASE_MOTHERSHIP) {
		happy = 0;
		[bipede.movement happy:rand() % 2];
		[bipede displayMessage:@"Yeah !" scale:1.0f];
		return YES;
	}
	return NO;
}

- (BOOL)update:(float)dt {
    CGRect collidRect = [bipede.currentJumpBase collidRect];
	if (happy > 1.5) {
		dir = (collidRect.origin.x + 700) - bipede.sprite.position.x > 0;
		[bipede.movement run:dir];
		happy = -1;
	} else if (happy >= 0) {
		happy += dt;
		return YES;
	}
	if (dir != (collidRect.origin.x + 700) - bipede.sprite.position.x > 0) {
		bipede.saved = YES;
		bipede.sprite.visible = NO;
		
		CCParticleSystemQuad *particles = [CCParticleSystemQuad particleWithFile:@"persoinship.plist"];
		particles.position = ccp(bipede.sprite.position.x, bipede.sprite.position.y + 20);
		particles.autoRemoveOnFinish = YES;
		[[Display sharedDisplay].screens[bipede.player].frontNode addChild:particles];
		return NO;
	}
	return YES;
}

- (int)getPriority {
	return 50;
}

- (void)end:(BOOL)interrupted {
	
}

- (void)dealloc {
	[super dealloc];
}

@end
