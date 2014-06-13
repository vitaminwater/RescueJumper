//
//  GameStateActionIntro.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

#import "LevelUpMenuController.h"

@class LevelUpMenuController;
@class SurvivalGameData;

@interface GameStateActionSurvivalIntro : GameStateAction<LevelUpMenuControllerDelegate> {
	
    SurvivalGameData *gameData;
	NSMutableArray *levelUpMenuControllers;
	BOOL done;
	NSArray *levelHelpers;
	
}

@end
