//
//  AvoidDanger.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/12/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "AvoidDanger.h"

#import "Game.h"
#import "PlayerData.h"

#import "Bipede.h"
#import "BlackHole.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"

#import "Display.h"

@implementation AvoidDanger

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game dangerPos:(CGPoint)_dangerPos {
	
	if (self = [super initWithBipede:bipedeArg game:_game]) {
		dangerPos = _dangerPos;
	}
	return self;
	
}

- (NSObject<Action> *)trigger {
    [bipede.movement run:dangerPos.x - bipede.sprite.position.x < 0];
    panicking = -1;
    [bipede displayMessage:@"!" scale:2.0f];
    if (bipede.player < game.nPlayer)
        [game.playerData[bipede.player] setBipedeActive:bipede active:NO];
    return self;
}

- (BOOL)update:(float)dt {
	if (panicking > 0) {
		panicking -= dt;
		panicking = (panicking < 0 ? 0 : panicking);
		return YES;
	} else if (panicking == 0) {
		return NO;
	}
	CGRect collidRect = [bipede.currentJumpBase collidRect];
	if ((bipede.Vx > 0 && bipede.sprite.position.x + bipede.Vx * dt > collidRect.origin.x + collidRect.size.width) ||
		(bipede.Vx < 0 && (bipede.sprite.position.x + bipede.Vx * dt < collidRect.origin.x/* || bipede.sprite.position.x - bipede.sprite.size.width / 2 + bipede.Vx * dt < -[Display sharedDisplay].scrollX*/))) {
		[bipede.movement fear:rand() % 2];
		panicking = 1;
		[bipede displayMessage:@"!" scale:2.0f];
	}
	return bipede.currentJumpBase != nil && bipede.currentJumpBase.active;
}

- (void)end:(BOOL)interrupted {
    if (bipede.player < game.nPlayer)
        [game.playerData[bipede.player] setBipedeActive:bipede active:YES];
}

- (NSInteger)getPriority {
	return 15;
}

- (void)dealloc {
	[super dealloc];
}

@end
