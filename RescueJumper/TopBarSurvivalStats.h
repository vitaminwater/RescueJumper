//
//  TopBarSurvivalStats.h
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Screen.h"

@class Game;
@class SurvivalGameData;
@class ShipProgress;

@interface TopBarSurvivalStats : CCNode<TopStat> {
    
    Game *game;
    SurvivalGameData *gameData;
    NSUInteger player;
    NSNumberFormatter *numberFormatter;
    ccTime time;
    
    CCLabelBMFont *levelLabel;
	CCLabelBMFont *scoreLabel;
	CCLabelBMFont *timeLeftLabel;
	CCLabelBMFont *timeForNext;
	CCLabelBMFont *coinLabel;
	CCLabelBMFont *bobLabel;
	CCLabelBMFont *zombieLabel;
    
    ShipProgress *shipProgress;
    
}

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player;
- (void)update:(ccTime)dt;

@end
