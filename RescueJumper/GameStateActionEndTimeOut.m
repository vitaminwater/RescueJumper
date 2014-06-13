//
//  GameStateActionEndTimeOut.m
//  RescueJumper
//
//  Created by Constantin on 8/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionEndTimeOut.h"

#import "ChainList.h"

#import "Display.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "JumpBase.h"

#import "LevelGenerator.h"
#import "LevelElementGenerator.h"
#import "MotherShipGenerator.h"

@implementation GameStateActionEndTimeOut

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
    
    if (self = [super initWithGame:_game gameData:_gameData]) {
        motherShipElement = [[MotherShipGenerator alloc] initWithGame:game gameData:_gameData];
		[levelGenerator.elements addEntry:[motherShipElement autorelease]];
    }
    return self;
    
}

- (BOOL)canTrigger {
    if (exit)
        return NO;
	return gameData.timeLeft == 0 && gameData.timeForNext == 0;
}

- (NSObject<Action> *) trigger {
	__block NSUInteger minX = 0;
	[game.jumpBases iterateOrRemove:^BOOL(id entry) {
		JumpBase *jumpBase = entry;
		CGRect lastRect = [jumpBase collidRect];
		if (minX < lastRect.origin.x + lastRect.size.width)
			minX = lastRect.origin.x + lastRect.size.width;
		return NO;
	} removeOnYES:NO exit:NO];
	motherShipElement.minX = minX + 20;
    [[Display sharedDisplay] displayMessage:NSLocalizedString(@"TimeOut", @"")];
	return self;
}

- (BOOL)update:(float)dt {
    if (!done) {
        for (int i = 0; i < game.nPlayer; ++i) {
            if (scoreMenuControllers && [scoreMenuControllers objectForKey:[NSNumber numberWithInt:i]])
                continue;
            if (!game.playerData[i].bipedes.count)
                [self showScores:i];
        }
    }
    return [super update:dt];
}

@end
