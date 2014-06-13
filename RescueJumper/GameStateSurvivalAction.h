//
//  GameStateSurvivalAction.h
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@class Game;
@class SurvivalGameData;
@class LevelGenerator;

@interface GameStateSurvivalAction : GameStateAction {
    
    SurvivalGameData *gameData;
    LevelGenerator *levelGenerator;
    BOOL showButtons;
    
}

@property(nonatomic, readonly)LevelGenerator *levelGenerator;
@property(nonatomic, readonly)BOOL showButtons;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData;

@end
