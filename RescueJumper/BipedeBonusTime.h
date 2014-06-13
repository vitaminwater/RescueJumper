//
//  BipedeBonusTime.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeBonus.h"

#import "ccTypes.h"

@class SurvivalGameData;

@interface BipedeBonusTime : BipedeBonus {
	
    SurvivalGameData *gameData;
	ccTime time;
	
}

@property(nonatomic, readonly)ccTime time;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game gameData:(SurvivalGameData *)_gameData time:(ccTime)_time;

@end
