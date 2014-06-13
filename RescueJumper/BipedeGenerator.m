//
//  BipedeGenerator.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeGenerator.h"

#import "ChainList.h"

#import "BipedeJumpBaseLvlUpPicker.h"
#import "BipedeJumpFurtherPicker.h"
#import "BipedeAddTimePicker.h"
#import "BipedeOctavePicker.h"
#import "BipedeNeutralPicker.h"
#import "BipedeBonus.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Bipede.h"
#import "Octave.h"
#import "BipedePicker.h"

#import "BuildingPlateforme.h"


@implementation BipedeGenerator

@synthesize nPendingBipedes;
@synthesize bipedePickers;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super init]) {
		game = _game;
        gameData = _gameData;
		bipedePickers = [[ChainList alloc] initWithAddCallbacks:@selector(dummyCallBack:) removeCallBack:@selector(dummyCallBack:) delegate:self];
		[bipedePickers addEntry:[[[BipedeJumpBaseLvlUpPicker alloc] initWithGame:game gameData:_gameData] autorelease]];
		[bipedePickers addEntry:[[[BipedeJumpFurtherPicker alloc] initWithGame:game gameData:_gameData] autorelease]];
		[bipedePickers addEntry:[[[BipedeAddTimePicker alloc] initWithGame:game gameData:_gameData] autorelease]];
		[bipedePickers addEntry:[[[BipedeOctavePicker alloc] initWithGame:game gameData:_gameData] autorelease]];
		[bipedePickers addEntry:[[[BipedeNeutralPicker alloc] initWithGame:game gameData:_gameData] autorelease]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelPassed:) name:LEVEL_PASSED object:nil];
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    nPendingBipedes = 0;
    [bipedePickers iterateOrRemove:^BOOL(id entry) {
        BipedePicker *picker = entry;
        if (!NSLocationInRange(gameData.currentLevel, [picker levelRange]))
			return NO;
        [picker update:dt];
        if ([picker canTrigger])
            nPendingBipedes += picker.nPendingBipedes;
        return NO;
    } removeOnYES:NO exit:NO];
}

- (void)generateBipedes:(ChainList *)jumpPlateFormes {
    
	[bipedePickers iterateOrRemove:^BOOL(id entry) {
		BipedePicker *picker = entry;
        if (!NSLocationInRange(gameData.currentLevel, [picker levelRange]))
			return NO;
		[picker generateBipedes:jumpPlateFormes];
		return NO;
	} removeOnYES:NO exit:NO];
}

- (void)levelPassed:(NSNotification *)note {
}

- (void)dummyCallBack:(id)entry {}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[bipedePickers release];
	[super dealloc];
}

@end
