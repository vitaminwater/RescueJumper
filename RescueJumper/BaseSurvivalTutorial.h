//
//  BaseSurvivalTutorial.h
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseTutorial.h"

@class Game;
@class SurvivalGameData;

@interface BaseSurvivalTutorial : BaseTutorial {
    
    SurvivalGameData *gameData;
    
}

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData;

@end
