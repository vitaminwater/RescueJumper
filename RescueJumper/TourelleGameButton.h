//
//  TourelleGameButton.h
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseGameButton.h"

@class SurvivalGameData;

@interface TourelleGameButton : BaseGameButton

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player;

@end
