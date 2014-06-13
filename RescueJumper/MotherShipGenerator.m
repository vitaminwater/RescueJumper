//
//  MotherShipElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "MotherShipGenerator.h"

#import "Display.h"
#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"

#import "Game.h"
#import "SurvivalGameData.h"
#import "MotherShip.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"

@implementation MotherShipGenerator

@synthesize minX;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		motherShip = nil;
		ended = NO;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	if (ended)
		return;
	if (motherShip == nil)
		[self execute];
	else {
		if (motherShip.sprite.position.x < -[Display sharedDisplay].scrollX + [Display sharedDisplay].size.width - motherShip.sprite.size.width / 2) {
			game.scrollSpeed = 0;
			ended = YES;
		}
	}
}

- (void)execute {
	motherShip = [[MotherShip alloc] initWithGame:game];
	if (minX + motherShip.sprite.size.width / 2 > motherShip.sprite.position.x) {
		CGPoint pos = motherShip.sprite.position;
		pos.x = minX + motherShip.sprite.size.width / 2;
		motherShip.sprite.position = pos;
	}
	[game.jumpBases addEntry:motherShip];
	[motherShip release];
	[super execute];
}

- (void)jumpBaseRemoved:(NSNotification *)note {
}

- (void)dealloc {
	[super dealloc];
}

@end
