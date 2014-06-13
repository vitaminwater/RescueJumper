//
//  AllDeadTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/11/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "AllDeadTutorial.h"

#import "Game.h"
#import "SurvivalGameData.h"
#import "PlayerData.h"

@implementation AllDeadTutorial

- (BOOL)canTrigger {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AllDeadTutorial"])
		return NO;
    return ![game.playerData[0].bipedes count] && gameData.timeLeft;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalAllDeadTutorial", @"")];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AllDeadTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AllDeadTutorial"];
}

@end
