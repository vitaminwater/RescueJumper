//
//  GameStateActionEndAllDead.m
//  RescueJumper
//
//  Created by Constantin on 8/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionEndAllDead.h"

#import "Game.h"
#import "PlayerData.h"

#import "Bipede.h"

@implementation GameStateActionEndAllDead

- (BOOL)update:(float)dt {
    game.scrollSpeed += -game.scrollSpeed * dt * 2.0f;
    return [super update:dt];
}

- (BOOL)canTrigger {
    if (exit)
        return NO;
	for (int i = 0; i < game.nPlayer; ++i) {
		if (!game.playerData[i].bipedes.count) {
			return YES;
		}
	}
	return NO;
}

- (NSObject<Action> *) trigger {
    for (int i = 0; i < game.nPlayer; ++i)
        [self showScores:i];
	return self;
}

@end
