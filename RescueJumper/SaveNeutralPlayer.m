//
//  SaveNeutralPlayer.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/15/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SaveNeutralPlayer.h"

#import "Game.h"
#import "JumpBase.h"
#import "Bipede.h"
#import "AnimatedDisplayObject.h"
#import "PlayerData.h"

#import "AvoidDanger.h"

@implementation SaveNeutralPlayer

-(BOOL)canTrigger
{
	if (ignoredJB && ignoredJB == bipede.currentJumpBase)
		return NO;
    ignoredJB = nil;
	if (bipede.currentJumpBase != nil && bipede.currentJumpBase.player == NEUTRAL_PLAYER) {
		__block BOOL result = NO;
		__block Bipede *nearest = nil;
		__block CGFloat dist = 10000;
		[bipede.currentJumpBase.onBoard iterateOrRemove:^BOOL(id entry) {
			Bipede *tmp = entry;
			if (tmp.dead)
				return NO;
			CGFloat newDist = fabs(tmp.sprite.position.x - bipede.sprite.position.x);
			if (tmp.player == NEUTRAL_PLAYER && !tmp.converting && (newDist < dist || nearest == nil)) {
				nearest = tmp;
				dist = newDist;
				result = YES;
			}
			return NO;
		} removeOnYES:NO exit:YES];
		if (result) {
			aimTmp = nearest;
		}
		return result;
	}
	return NO;
}

- (NSObject<Action> *)trigger {
	aim = [aimTmp retain];
	aim.converting = YES;
	[aim.movement stand:(aim.sprite.position.x - bipede.sprite.position.x) < 0];
	dir = (aim.sprite.position.x + (aim.movement.right ? 20 : -20)) - bipede.sprite.position.x > 0;
	[bipede.movement run:dir];
	return [super trigger];
}

-(int)getPriority
{
	return 10;
}

-(BOOL)update:(float)dt {
	if (waiting) {
		waitingTime -= dt;
		if (waitingTime < 0) {
			[aim convertToPlayer:bipede.player];
			[aim displayMessage:@"thx!" scale:1.0f];
			[bipede displayMessage:nil scale:0];
			[bipede.movement stand:rand() % 2];
			waiting = NO;
		}
		return waitingTime >= 0;
	}
	if (aim.player != NEUTRAL_PLAYER || bipede.dead || bipede.currentJumpBase != aim.currentJumpBase)
		return NO;
	if (dir != (aim.sprite.position.x + (aim.movement.right ? 20 : -20)) - bipede.sprite.position.x > 0) {
		waitingTime = 0.5;
		waiting = YES;
		[bipede.movement speak:aim.sprite.position.x - bipede.sprite.position.x > 0];
		[aim displayMessage:nil scale:0];
		[bipede displayMessage:@"Blabla ?" scale:0.8f];
		return YES;
	}
	return YES;
}

- (void)end:(BOOL)interrupted {
    if (interrupted && bipede.currentJumpBase) {
        ignoredJB = bipede.currentJumpBase;
    }
	aim.converting = NO;
	[aim release];
	aim = nil;
}

- (void)dealloc {
	[aim release];
	[super dealloc];
}

@end
