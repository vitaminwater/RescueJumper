//
//  SurvivalGameData.m
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SurvivalGameData.h"

@implementation SurvivalGameData

@synthesize totalTime;
@synthesize timeLeft;
@synthesize currentLevelTotalTime;
@synthesize timeForNext;
@synthesize currentLevel;

@synthesize shipProgress;

- (id)init {
    
    if (self = [super init]) {
        totalTime = 0;
        timeLeft = 80;
        currentLevelTotalTime = 80;
        timeForNext = 0;
        currentLevel = 1;
        
        shipProgress = 0;
    }
    return self;
    
}

- (void)dealloc {
    [super dealloc];
}

@end
