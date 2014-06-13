//
//  GameStateActionEnd.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionEnd.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"
#import "TouchManager.h"

#import "ScoreMenuController.h"

#import "Display.h"

#import "LevelGenerator.h"

#import "HomeMenu.h"
#import "LevelSelectorMenu.h"

#import "AppDelegate.h"

@implementation GameStateActionEnd

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		scoreMenuControllers = nil;
		done = NO;
        exit = NO;
	}
	return self;
	
}

- (BOOL)canTrigger {
    return !exit;
}

- (int)getPriority {
	return scoreMenuControllers ? 4242 : 20;
}

- (BOOL)update:(float)dt {
    for (id key in [scoreMenuControllers allKeys]) {
        ScoreMenuController *scoreMenuController = [scoreMenuControllers objectForKey:key];
        [scoreMenuController update:dt];
    }
	
	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] update:dt];
	
	[game processJumpBases:dt];
	[game processCollidRect:dt];
	[game processBipedes:dt];
	[levelGenerator update:dt];
	return !exit;
}

- (void)end:(BOOL)_interrupted {

}

- (void)showScores:(NSUInteger)player {
	if (!scoreMenuControllers) {
		scoreMenuControllers = [[NSMutableDictionary dictionary] retain];
	}
    ScoreMenuController *scoreMenuController = [[ScoreMenuController alloc] initWithGame:game gameData:gameData player:player gameStateActionEnd:self];
	[scoreMenuControllers setObject:scoreMenuController forKey:[NSNumber numberWithInt:player]];

	[(AppDelegate *)[UIApplication sharedApplication].delegate showMenu:scoreMenuController player:player];
    [scoreMenuController release];

	//[TestFlight passCheckpoint:
	// [NSString stringWithFormat:@"END_GAME %@",
	//  (gameData.timeLeft > 0 ? @"FAILED" : @"TIME_END")]];
	
    done = [[scoreMenuControllers allKeys] count] == game.nPlayer;
}

- (void)scoreMenuExited:(ScoreMenuController *)_scoreMenu {
	[(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:_scoreMenu];
	[scoreMenuControllers removeObjectForKey:[NSNumber numberWithInt:_scoreMenu.player]];
	
	exit = ![[scoreMenuControllers allKeys] count];
	
	if (exit) {
        [game unscheduleAllSelectors];
        [[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
        if (game.nPlayer > 1)
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HomeMenu scene]]];
        else
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[LevelSelectorMenu scene]]];
	}
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	if (scoreMenuControllers && [scoreMenuControllers objectForKey:[NSNumber numberWithInt:player]])
		return NO;
	return [game.touchManager[player] touchBegan:touch withEvent:event];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[game.touchManager[player] touchMoved:touch withEvent:event];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[game.touchManager[player] touchEnded:touch withEvent:event];
}

- (void)dealloc {
    [scoreMenuControllers release];
	[super dealloc];
}

@end
