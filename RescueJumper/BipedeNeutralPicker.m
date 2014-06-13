//
//  NeutralBipedePicker.m
//  RescueJumper
//
//  Created by Constantin on 8/11/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeNeutralPicker.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

@implementation BipedeNeutralPicker

- (BOOL)canTrigger {
    NSUInteger nBipedes = [game.pnjs count];
    for (int i = 0; i < game.nPlayer; ++i)
        nBipedes += [game.playerData[i].bipedes count];
    NSUInteger nRequiredBipedes = [BipedeNeutralPicker calcRequiredBipedes:game gameData:gameData];
    if (nRequiredBipedes <= nBipedes)
        return NO;
    nPendingBipedes = nRequiredBipedes - nBipedes;
    return nPendingBipedes >= (CGFloat)nRequiredBipedes * 0.3;
}

- (void)generateBipedes:(ChainList *)jumpBases {
    if (!nPendingBipedes)
        nPendingBipedes = ceilf((CGFloat)gameData.currentLevel * 0.3f);
    nPendingBipedes = nPendingBipedes > 30 ? 30 : nPendingBipedes;
	//NSLog(@"creating %d bipede for %d required.", nPendingBipedes, [BipedeNeutralPicker calcRequiredBipedes:game]);
    NSUInteger nBipedesPerJB = ceilf((CGFloat)nPendingBipedes / (CGFloat)[jumpBases count]);
    [jumpBases iterateOrRemove:^BOOL(id entry) {
        for (int i = 0; i < nBipedesPerJB; ++i)
            [self createBipede:entry];
        return NO;
    } removeOnYES:NO exit:NO];
    nPendingBipedes = 0;
}

+ (NSUInteger)calcRequiredBipedes:(Game *)game gameData:(SurvivalGameData *)gameData {
    CGFloat currentLevelAdvancement = (gameData.currentLevelTotalTime - gameData.timeLeft) / gameData.currentLevelTotalTime;
    NSUInteger nRequiredBipedesLevelBegin = 4 * gameData.currentLevel;
    NSUInteger nRequiredBipedesLevelEnd = (4 * (gameData.currentLevel + 1));
    NSUInteger nRequiredBipedes = nRequiredBipedesLevelBegin + (CGFloat)(nRequiredBipedesLevelEnd - nRequiredBipedesLevelBegin) * currentLevelAdvancement;
    return nRequiredBipedes;
}

@end
