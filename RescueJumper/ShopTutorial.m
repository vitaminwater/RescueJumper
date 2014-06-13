//
//  ShopTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/11/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ShopTutorial.h"

#import "SurvivalGameData.h"

@implementation ShopTutorial

- (BOOL)canTrigger {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShopTutorial"])
		return NO;
    return !gameData.timeLeft && gameData.timeForNext && gameData.currentLevel == 6;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalShopTutorial", @"")];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShopTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShopTutorial"] || gameData.currentLevel > 6;
}

@end
