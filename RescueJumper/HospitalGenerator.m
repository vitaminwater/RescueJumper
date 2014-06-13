//
//  HospitalElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HospitalGenerator.h"

#import "Hospital.h"

#import "Display.h"
#import "DisplayObject.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"

@implementation HospitalGenerator

@synthesize waitNext;
@synthesize waitSince;
@synthesize minX;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		hospital = nil;
		waitNext = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	if (waitNext) {
		waitSince += dt;
		return;
	}
	if (!gameData.timeLeft && hospital == nil)
		[self execute];
	else if (hospital != nil && !waitNext) {
		if (hospital.sprite.position.x < -[Display sharedDisplay].scrollX - hospital.sprite.size.width / 2 + [Display sharedDisplay].size.width) {
			game.scrollSpeed = 0;
			waitNext = YES;
			waitSince = 0;
		}
	}
}

- (void)execute {
	hospital = [[Hospital alloc] initWithGame:game];
	waitSince = 0;
	if (minX + hospital.sprite.size.width / 2 > hospital.sprite.position.x) {
		CGPoint pos = hospital.sprite.position;
		pos.x = minX + hospital.sprite.size.width / 2;
		[hospital setPosition:pos];
	}
	[game.jumpBases addEntry:hospital];
	[hospital release];
	[super execute];
}

- (void)jumpBaseRemoved:(NSNotification *)note {
	if ([note object] == hospital) {
		waitNext = NO;
		hospital = nil;
	}
}

- (NSUInteger)onBoard {
	return hospital.onBoard.count;
}

- (void)activate {
	hospital.canHaveNext = YES;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
