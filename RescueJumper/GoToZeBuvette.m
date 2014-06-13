//
//  GoToZeBuvette.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/19/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GoToZeBuvette.h"

#import "AnimatedDisplayObject.h"

#import "Hospital.h"

#import "Bipede.h"

@implementation GoToZeBuvette

static int currentlyIn = 0;

- (BOOL)canTrigger {
	if (bipede.currentJumpBase != nil && [bipede.currentJumpBase type] == JUMPBASE_HOSPITAL && !bipede.currentJumpBase.canHaveNext) {
		return YES;
	}
	return NO;
}

- (NSObject<Action> *)trigger {
	happy = 0;
	waiting = NO;
	[bipede.movement happy:rand() % 2];
	[bipede displayMessage:@"Yeah !" scale:1.0f];
	return [super trigger];
}

- (BOOL)update:(float)dt {
	if (happy > 1.5) {
		collidRect = [bipede.currentJumpBase collidRect];
		dir = (collidRect.origin.x + collidRect.size.width / 2) - bipede.sprite.position.x > 0;
		[bipede.movement run:dir];
		happy = -1;
	} else if (happy >= 0) {
		happy += dt;
		return YES;
	}
	if (dir != (collidRect.origin.x + collidRect.size.width / 2) - bipede.sprite.position.x > 0 && !waiting) {
		bipede.Vx = 0;
		[bipede.movement stand:rand() % 2];
		[bipede displayMessage:nil scale:1.0f];
		++currentlyIn;
		//if (currentlyIn == 1)
			//[[SimpleAudioEngine sharedEngine] playEffect:@"hosto.wav"];
		waiting = YES;
		return YES;
	}
	return !bipede.currentJumpBase.canHaveNext;
}

- (int)getPriority {
	return 50;
}

- (void)end:(BOOL)interrupted {
	--currentlyIn;
}

- (void)dealloc {
	[super dealloc];
}

@end
