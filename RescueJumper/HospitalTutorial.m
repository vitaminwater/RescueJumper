//
//  HospitalTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HospitalTutorial.h"

#import "ChainList.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "JumpBase.h"
#import "Hospital.h"

@implementation HospitalTutorial

- (BOOL)canTrigger {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HospitalTutorial"])
		return NO;
    return !gameData.timeLeft && gameData.timeForNext;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalHospitalTutorial", @"")];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HospitalTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"HospitalTutorial"] || gameData.currentLevel > 1;
}

@end
