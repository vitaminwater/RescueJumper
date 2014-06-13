//
//  BaseSurvivalTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseSurvivalTutorial.h"

#import "Game.h"

@implementation BaseSurvivalTutorial

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
    
    if (self = [super initWithGame:_game]) {
        gameData = [_gameData retain];
    }
    return self;
}

- (void)dealloc {
    [gameData release];
    [super dealloc];
}

@end
