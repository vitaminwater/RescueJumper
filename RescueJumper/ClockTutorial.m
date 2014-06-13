//
//  ClockTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ClockTutorial.h"

#import "Game.h"

#import "Bipede.h"
#import "BipedeBonusTime.h"

@implementation ClockTutorial

- (BOOL)canTrigger {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ClockTutorial"])
		return NO;
    __block BOOL result = NO;
    [game.pnjs iterateOrRemove:^BOOL(id entry) {
        Bipede *bipede = entry;
        if (bipede.bonus && [bipede.bonus isKindOfClass:[BipedeBonusTime class]]) {
            result = YES;
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    return result;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalClockGuyTutorial", @"")];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ClockTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ClockTutorial"];
}

@end
