//
//  LevelGenerator.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/3/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@class Game;
@class SurvivalGameData;
@class ChainList;

@interface LevelGenerator : NSObject {
	
	Game *game;
    SurvivalGameData *gameData;
	ChainList *elements;
	ccTime currentTime;
	
}

@property(nonatomic, assign)ccTime currentTime;
@property(nonatomic, readonly)ChainList *elements;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData;
- (void)update:(ccTime)dt;

@end
