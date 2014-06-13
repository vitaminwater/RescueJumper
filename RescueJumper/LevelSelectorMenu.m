//
//  LevelSelectorMenu.m
//  RescueJumper
//
//  Created by Constantin on 12/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelSelectorMenu.h"

#import "AppDelegate.h"
#import "LevelSelectorViewController.h"

#import "GameLevel1.h"
#import "GameLevel2.h"
#import "GameLevel3.h"
#import "GameLevel4.h"

@implementation LevelSelectorMenu

- (id)init {
    
    if (self = [super init]) {
        levels = [[NSMutableArray array] retain];
        [levels addObject:[[[GameLevel1 alloc] init] autorelease]];
        [levels addObject:[[[GameLevel2 alloc] init] autorelease]];
        [levels addObject:[[[GameLevel3 alloc] init] autorelease]];
        [levels addObject:[[[GameLevel4 alloc] init] autorelease]];
        
        levelSelectorViewController = [[LevelSelectorViewController alloc] initWithLevels:levels];
        [((AppDelegate *)[UIApplication sharedApplication].delegate) showMenu:levelSelectorViewController player:-1];
    }
    return self;
    
}

- (void)dealloc {
    [(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelSelectorViewController];
    [levelSelectorViewController release];
    levelSelectorViewController = nil;
    [levels release];
    [super dealloc];
}

@end
