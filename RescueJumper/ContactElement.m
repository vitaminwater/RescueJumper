//
//  ContactGameElement.m
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ContactElement.h"

#import "AnimatedDisplayObject.h"

#import "Game.h"
#import "PlayerData.h"

#import "Bipede.h"

@implementation ContactElement

- (BOOL)execute:(Bipede *)bipede dt:(ccTime)dt { return YES; }

- (void)update:(ccTime)dt {
    BOOL (^checkBlock)(id entry) = ^BOOL(id entry) {
		Bipede *bipede = entry;
		return [self checkBipede:dt bipede:bipede];
	};
    [game.pnjs iterateOrRemove:checkBlock removeOnYES:NO exit:YES];
	for (int i = 0; i < game.nPlayer; ++i) {
		[game.playerData[i].bipedes iterateOrRemove:checkBlock removeOnYES:NO exit:YES];
	}
}

- (BOOL)checkBipede:(ccTime)dt bipede:(Bipede *)bipede {
	if ([self testCollid:bipede dt:dt]) {
		return [self execute:bipede dt:dt];
	}
	return NO;
}

- (BOOL)testCollid:(Bipede *)bipede dt:(ccTime)dt {
	return CGRectIntersectsRect([self collidRect],
								CGRectMake(bipede.sprite.position.x - bipede.sprite.size.width / 2 + bipede.Vx * dt, bipede.sprite.position.y,
                                           bipede.sprite.size.width, bipede.sprite.size.height));
}

@end
