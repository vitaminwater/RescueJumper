//
//  GameStateSurvivalAction.m
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateSurvivalAction.h"

#import "SurvivalGameData.h"
#import "LevelGenerator.h"

@implementation GameStateSurvivalAction

@synthesize levelGenerator;
@synthesize showButtons;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
    
    if (self = [super initWithGame:_game]) {
        gameData = [_gameData retain];
        showButtons = NO;
		levelGenerator = [[LevelGenerator alloc] initWithGame:game gameData:gameData];
    }
    return self;
    
}

- (void)dealloc {
    [gameData release];
    [levelGenerator release];
    [super dealloc];
}

@end
