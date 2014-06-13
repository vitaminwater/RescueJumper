//
//  SwallowByBlackHole.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/15/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SwallowByBlackHole.h"
#import "BlackHole.h"

#import "Bipede.h"
#import "AnimatedDisplayObject.h"

#import "Game.h"
#import "PlayerData.h"
#import "MBDACenter.h"

@implementation SwallowByBlackHole

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game blackHole:(BlackHole *)_blackHole {
	
	if (self = [super initWithBipede:bipedeArg game:_game]) {
		blackHole = [_blackHole retain];
	}
	return self;
	
}

- (NSObject<Action> *)trigger {
    rotSpeed = 300 + rand() % 60;
    bipede.currentJumpBase = nil;
    bipede.sprite.position = ccp(bipede.sprite.position.x, bipede.sprite.position.y + bipede.sprite.size.height / 2);
    bipede.sprite.anchor = ccp(0.5, 0.5);
    [bipede.movement jump:rand() % 2];
    if (bipede.player < game.nPlayer) {
        [game.playerData[bipede.player] setBipedeActive:bipede active:NO];
        [[SimpleAudioEngine sharedEngine] playEffect:@"scream.wav"];
    }
    bipede.dead = YES;
    [[MBDACenter sharedMBDACenter].aims iterateOrRemove:^BOOL(id entry) {
        return entry == bipede.movement;
    } removeOnYES:YES exit:YES];
    return self;
}

- (BOOL)update:(float)dt {
	if (bipede.sprite.scale <= 0) {
		bipede.sprite.visible = NO;
		return NO;
	}
	bipede.sprite.scale -= dt / 4.0f;
	bipede.sprite.rotation += rotSpeed * dt;
	
	CGFloat distX = blackHole.sprite.position.x - bipede.sprite.position.x;
	CGFloat distY = blackHole.sprite.position.y - (bipede.sprite.position.y);
	CGFloat distance = sqrtf(powf(distX, 2) + powf(distY, 2));
	distX /= distance;
	distY /= distance;
	bipede.Vx = distX * 80.0f;
	bipede.Vy = distY * 80.0f;
	return YES;
}

- (int)getPriority {
	return 50;
}

- (void)dealloc {
	[blackHole release];
	[super dealloc];
}

@end
