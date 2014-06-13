//
//  GameStateActionSurvivalTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionSurvivalTutorial.h"

#import "SurvivalGameData.h"

#import "ChainList.h"

#import "WelcomeTutorial.h"
#import "PlateformeTutorial.h"
#import "SaveSiblingsTutorial.h"
#import "ShipTutorial.h"
#import "CrowdedPlateformeTutorial.h"
#import "ClockTutorial.h"
#import "HospitalTutorial.h"
#import "ShopTutorial.h"
#import "TimeOutTutorial.h"
#import "AllDeadTutorial.h"

@implementation GameStateActionSurvivalTutorial

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)gameData {
	
	if (self = [super initWithGame:_game]) {
		[tutorials addEntry:[[[WelcomeTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[PlateformeTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[SaveSiblingsTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[ShipTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[CrowdedPlateformeTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[ClockTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[HospitalTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[ShopTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[TimeOutTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
		[tutorials addEntry:[[[AllDeadTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
	}
	return self;
	
}

@end
