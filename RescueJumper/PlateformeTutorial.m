//
//  FirstPlateformeTutorial.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "PlateformeTutorial.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Display.h"
#import "TextDisplayObject.h"

#import "JumpBase.h"

@implementation PlateformeTutorial

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
	}
	return self;
	
}

- (BOOL)canTrigger {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PlateformeTutorial"])
		return NO;
	if (gameData.totalTime >= 3.0f) {
		__block NSUInteger nJumpBases = 0;
		[game.jumpBases iterateOrRemove:^BOOL(id entry) {
			JumpBase *current = entry;
			if (current.player == PLAYER1) {
				theOne = current;
				++nJumpBases;
			}
			return NO;
		} removeOnYES:NO exit:NO];
		return nJumpBases == 1;
	}
	return NO;
}

- (void)trigger {
	[super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalPlateformeTutorial", @"")];
    [self addTutorialHand:theOne.sprite.position to:ccpAdd(theOne.sprite.position, ccp(300, 0)) delay:1.0f];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PlateformeTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
	return [game.jumpBases count] > 1 || gameData.totalTime >= 4.0f || [[NSUserDefaults standardUserDefaults] boolForKey:@"PlateformeTutorial"];
}

- (void)dealloc {
	[super dealloc];
}

@end