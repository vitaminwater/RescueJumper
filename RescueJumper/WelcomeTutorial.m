//
//  WelcomeTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "WelcomeTutorial.h"

@implementation WelcomeTutorial

- (BOOL)canTrigger {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WelcomeTutorial"])
		return NO;
    return YES;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalWelcomeTutorial", @"")];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WelcomeTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"WelcomeTutorial"];
}

@end
