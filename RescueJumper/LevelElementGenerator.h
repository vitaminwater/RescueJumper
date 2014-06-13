//
//  LevelElement.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ccTypes.h"

#import "BaseGameElement.h"

@class Game;
@class LevelGenerator;
@class SurvivalGameData;
@class ChainList;

@interface LevelElementGenerator : NSObject<GameElementDelegate> {
	
	Game *game;
	ccTime timeToNext;
    SurvivalGameData *gameData;
	
	LevelGenerator *levelGenerator;
    
    ChainList *generatedElements;
	
}

@property(nonatomic, assign)LevelGenerator *levelGenerator;
@property(nonatomic, readonly)ChainList *generatedElements;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData;
- (void)update:(ccTime)dt;
- (BOOL)canTrigger;
- (void)execute;
- (void)removeGeneratedElement:(id)generatedElement;

- (NSRange)levelRange;
- (ccTime)getTimeToNext;
- (CGRect)lastRect;

@end
