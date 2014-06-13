//
//  BipedeJumpFurtherPicker.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeJumpFurtherPicker.h"

#import "ChainList.h"

#import "Game.h"

#import "Bipede.h"
#import "BipedeBonusIncJumpDistance.h"

@implementation BipedeJumpFurtherPicker

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
        timeToNext = 0;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    [super update:dt];
    timeToNext -= dt;
}

- (BOOL)canTrigger {
    if (timeToNext < 0){
        nPendingBipedes = 1;
        return YES;
    }
    return NO;
}

- (void)generateBipedes:(ChainList *)jumpBases {
    if (![self canTrigger])
        return;
    __block NSUInteger i = rand() % [jumpBases count];
    [jumpBases iterateOrRemove:^BOOL(id entry) {
        if (!(i--)) {
            JumpBase *jumpBase = entry;
            Bipede *bipede = [self createBipede:jumpBase];
            BipedeBonusIncJumpDistance *bonus = [[BipedeBonusIncJumpDistance alloc] initWithBipede:bipede game:game];

            bipede.bonus = bonus;
            [bonus release];
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    nPendingBipedes = 0;
	timeToNext = (rand() % 40 + 60) / game.nPlayer;
	return;
}

- (NSRange)levelRange {
	return NSMakeRange(4, 424242);
}

@end
