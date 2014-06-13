//
//  EndLevelGameStateAction.h
//  RescueJumper
//
//  Created by Constantin on 12/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@class LevelEndViewController;

@interface GameStateActionLevelEnd : GameStateAction {
    
    LevelEndViewController *levelEndViewController;
    
    NSString *title;
    NSString *message;
    NSUInteger grade;
}

- (id)initWithGame:(Game *)_game title:(NSString *)_title message:(NSString *)_message grade:(NSUInteger)_grade;

@end
