//
//  TimeOutTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/10/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TimeOutTutorial.h"

#import "SurvivalGameData.h"

@implementation TimeOutTutorial

- (BOOL)canTrigger {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TimeOutTutorial"])
		return NO;
    return !gameData.timeLeft && !gameData.timeForNext;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalTimeOutTutorial", @"")];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TimeOutTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TimeOutTutorial"];
}

@end
