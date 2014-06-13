//
//  LevelGenerator.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/3/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelGenerator.h"

#import "Game.h"
#import "SurvivalGameData.h"
#import "ChainList.h"

#import "LevelElementGenerator.h"
#import "BuildingGenerator.h"
#import "ShipGenerator.h"
#import "CoinGenerator.h"
#import "CollidObjectGenerator.h"
#import "BlackHoleGenerator.h"
#import "MotherShipGenerator.h"

@implementation LevelGenerator

@synthesize currentTime;
@synthesize elements;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	self = [super init];
	if (self) {
		game = _game;
        gameData = _gameData;
		currentTime = 0.0f;
		elements = [[ChainList alloc] initWithAddCallbacks:@selector(elementAdded:) removeCallBack:@selector(dummySelector:) delegate:self];
	}
	return self;
}

- (void)update:(ccTime)dt {
	[elements iterateOrRemove:^BOOL(id entry) {
		LevelElementGenerator *element = entry;
		if (!NSLocationInRange(gameData.currentLevel, [element levelRange]))
			return NO;
		[element update:dt];
		return NO;
	} removeOnYES:NO exit:NO];
	currentTime += dt;
}

- (void)elementAdded:(LevelElementGenerator *)element {
	element.levelGenerator = self;
}

- (void)dummySelector:(id)entry {}

- (void)dealloc {
	[elements release];
	[super dealloc];
}

@end
