//
//  BipedeBonusPicker.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ccTypes.h"

@class Game;
@class SurvivalGameData;
@class Bipede;
@class ChainList;
@class JumpBase;

@interface BipedePicker : NSObject {
	
	Game *game;
    SurvivalGameData *gameData;
	NSUInteger nPendingBipedes;
    
}

@property(nonatomic, readonly)NSUInteger nPendingBipedes;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData;
- (void)update:(ccTime)dt;
- (BOOL)canTrigger;
- (void)generateBipedes:(ChainList *)jumpBases;
- (Bipede *)createBipede:(JumpBase *)jumpBase;
- (NSRange)levelRange;

@end
