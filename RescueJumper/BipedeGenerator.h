//
//  BipedeGenerator.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ccTypes.h"

@class ChainList;
@class BuildingPlateforme;
@class Game;
@class SurvivalGameData;

@interface BipedeGenerator : NSObject {
	
	ChainList *bipedePickers;
	Game *game;
    SurvivalGameData *gameData;
	
    NSUInteger nPendingBipedes;
    
}

@property(nonatomic, readonly)NSUInteger nPendingBipedes;
@property(nonatomic, readonly)ChainList *bipedePickers;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData;
- (void)update:(ccTime)dt;
- (void)generateBipedes:(ChainList *)jumpPlateFormes;

@end
