//
//  BipedeJumpBaseLvlUpPicker.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeJumpBaseLvlUpPicker.h"
#import "BipedeBonusLvlUp.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "Bipede.h"

@implementation BipedeJumpBaseLvlUpPicker

@synthesize currentlyOnField;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
        currentlyOnField = 0;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    [super update:dt];
    timeToNext -= dt;
}

- (BOOL)canTrigger {
    if (timeToNext > 0)
        return NO;
	if (self.currentlyOnField < game.nPlayer) {
		NSUInteger wantedLvl = 1 + gameData.currentLevel / 3;
		wantedLvl = wantedLvl > 3 ? 3 : wantedLvl;
		for (int i = 0; i < game.nPlayer; ++i) {
			if (game.playerData[i].jumpBaseLevel < wantedLvl) {
                nPendingBipedes = 1;
				return YES;
            }
		}
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
            BipedeBonusLvlUp *bonus = [[BipedeBonusLvlUp alloc] initWithBipede:bipede game:game];
            bipede.bonus = bonus;
            [bonus release];
            currentlyOnField++;
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    nPendingBipedes = 0;
	timeToNext = (rand() % 30 + 15) / game.nPlayer;
}

- (NSRange)levelRange {
	return NSMakeRange(3, 424242);
}

- (void)dummy:(id)entry {}

@end
