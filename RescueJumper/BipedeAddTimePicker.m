//
//  BipedeAddTimePicker.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeAddTimePicker.h"
#import "BipedeBonusTime.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Bipede.h"

@interface BipedeAddTimePicker ()

- (void)resetInterval;
- (void)resetNBipedes;
- (NSUInteger)totalOnField;

@end

@implementation BipedeAddTimePicker

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
        waitTime = 0;
        interval = -1;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    waitTime += dt;
}

- (BOOL)canTrigger {
    if (interval < 0)
        [self resetInterval];
    
    if (waitTime >= interval && [self timeToGive]) {
        [self resetNBipedes];
        return YES;
    }
    return NO;
}

- (void)generateBipedes:(ChainList *)jumpBases {

    if (![self timeToGive])
        return;

    [self resetNBipedes];
    
    if (!nPendingBipedes)
        return;

    [jumpBases iterateOrRemove:^BOOL(id entry) {
        for (int i = 0; i < nPendingBipedes; ++i) {
            JumpBase *jumpBase = entry;
            Bipede *bipede = [self createBipede:jumpBase];
            BipedeBonusTime *bonus = [[BipedeBonusTime alloc] initWithBipede:bipede game:game gameData:gameData time:timeGiven / [jumpBases count]];
            
            bipede.bonus = bonus;
            [bonus release];
            currentlyOnField[NEUTRAL_PLAYER] += bonus.time;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    nPendingBipedes = 0;
    [self resetInterval];
    waitTime = interval;
    return;
}

- (void)levelPassed:(NSNotification *)note {
    [self resetInterval];
    waitTime = 0;
}

- (ccTime)levelGivenTime {
    ccTime result = gameData.currentLevel + 13;
    result = result > 22.0f ? 22.0f : result;
    return result;
}

- (BOOL)timeToGive {
    return [self totalOnField] < 40.0f && [self totalOnField] + gameData.timeForNext < 80.0f;
}

- (void)resetInterval {
    interval = (gameData.currentLevelTotalTime) / (ceilf((80.0f - gameData.timeForNext - [self totalOnField]) / [self levelGivenTime]) + 1);
}

- (void)resetNBipedes {
    
    if (!interval) {
        timeGiven = 0;
        return;
    }
    
    nPendingBipedes = roundf(waitTime / interval);
    
    if (!nPendingBipedes) {
        timeGiven = 0;
        return;
    }
    
    if (nPendingBipedes > 1)
        timeGiven = [self levelGivenTime] * ((waitTime / (CGFloat)nPendingBipedes) / interval);
    else
        timeGiven = [self levelGivenTime];
    
    if (timeGiven * nPendingBipedes + [self totalOnField] + gameData.timeForNext > 80)
        timeGiven = (80 - ([self totalOnField] + gameData.timeForNext)) / nPendingBipedes;
    
    return;
}

- (NSUInteger)totalOnField {
    return currentlyOnField[PLAYER1] + currentlyOnField[PLAYER2] + currentlyOnField[NEUTRAL_PLAYER];
}

@end
