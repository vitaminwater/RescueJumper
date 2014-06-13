//
//  BipedeOctavePicker.m
//  RescueJumper
//
//  Created by Constantin on 8/11/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeOctavePicker.h"

#import "ChainList.h"

#import "Game.h"

#import "JumpBase.h"

#import "Octave.h"

@implementation BipedeOctavePicker

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
    
    if (self = [super initWithGame:_game gameData:_gameData]) {
        done = NO;
    }
    return self;
    
}

- (BOOL)canTrigger {
    return !done;
}

- (void)generateBipedes:(ChainList *)jumpBases {
    if (![self canTrigger])
        return;
    __block NSUInteger i = rand() % [jumpBases count];
    [jumpBases iterateOrRemove:^BOOL(id entry) {
        if (!(i--)) {
            JumpBase *jumpBase = entry;
            [self createBipede:jumpBase];
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    done = YES;
    nPendingBipedes = 0;
}

- (Bipede *)createBipede:(JumpBase *)jumpBase {
    Bipede *bipede = [[Octave alloc] initWithJumpBase:jumpBase player:NEUTRAL_PLAYER game:game];
    bipede.picker = self;
    [game.pnjs addEntry:bipede];
    [bipede release];
    return bipede;
}

- (void)levelPassed:(NSNotification *)note {
    done = NO;
    nPendingBipedes = 1;
}

- (NSRange)levelRange {
	return NSMakeRange(6, 424242);
}

@end
