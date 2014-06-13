//
//  GameStateActionLevelUp.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateSurvivalAction.h"

#import "LevelUpMenuController.h"

@class HospitalGenerator;

@interface GameStateActionLevelUp : GameStateSurvivalAction<LevelUpMenuControllerDelegate> {
	
	NSMutableArray *levelUpMenuControllers;
	HospitalGenerator *hospitalElement;
	
	BOOL exit;
	BOOL helperShown;
	
	NSArray *levelHelpers;
	
}

- (void)showNext;
- (void)startNextLevel:(id)sender;

@end
