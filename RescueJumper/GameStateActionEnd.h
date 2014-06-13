//
//  GameStateActionEnd.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateSurvivalAction.h"

@class ScoreMenuController;
@class MotherShipGenerator;

@interface GameStateActionEnd : GameStateSurvivalAction {
	
	NSMutableDictionary *scoreMenuControllers;
	
	BOOL done;
    BOOL exit;
	
}

- (void)showScores:(NSUInteger)player;
- (void)scoreMenuExited:(ScoreMenuController *)_scoreMenu;

@end
