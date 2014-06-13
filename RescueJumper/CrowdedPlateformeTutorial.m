//
//  CrowdedPlateforme.m
//  RescueJumper
//
//  Created by Constantin on 8/27/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CrowdedPlateformeTutorial.h"

#import "cocos2d.h"

#import "Game.h"

#import "JumpPlateforme.h"

@implementation CrowdedPlateformeTutorial

- (BOOL)canTrigger {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CrowdedPlateformeTutorial"])
		return NO;
    __block BOOL result = NO;
    [game.jumpBases iterateOrRemove:^BOOL(id entry) {
        JumpBase *current = entry;
        if (current.nLinks >= 2) {
            toDelete = YES;
            return YES;
        }
        if ([entry class] != [JumpPlateforme class])
            return NO;
        if (!plateforme && current.currentLoad >= current.capacityMax && current.Vy <= -79) {
            result = YES;
            plateforme = (JumpPlateforme *)current;
        }
        return NO;
    } removeOnYES:NO exit:YES];
	return result && !toDelete;
}

- (void)trigger {
	[super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalCrowdedPlateformeTutorial", @"")];
    CGRect collidRect = [plateforme collidRect];
    CGPoint from = ccp(collidRect.origin.x + collidRect.size.width / 2, collidRect.origin.y + collidRect.size.height / 2);
    [self addTutorialHand:from to:ccpAdd(from, ccp(200.0f, 150.0f)) delay:1.0f];
    [self addTutorialHand:from to:ccpAdd(from, ccp(200.0f, -150.0f)) delay:2.0f];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CrowdedPlateformeTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
	return toDelete || [[NSUserDefaults standardUserDefaults] boolForKey:@"CrowdedPlateformeTutorial"];
}

@end
