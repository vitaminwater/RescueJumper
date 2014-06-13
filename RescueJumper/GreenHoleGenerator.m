//
//  GreenHoleElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/23/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GreenHoleGenerator.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Display.h"

#import "GreenHole.h"

#import "StaticDisplayObject.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"
#import "BlackHoleGenerator.h"

@implementation GreenHoleGenerator

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		timeToNext = 10;
		size = 0.5f;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    CGRect lastRect = [self lastRect];
    if (lastRect.origin.x + lastRect.size.width < -[Display sharedDisplay].scrollX + [Display sharedDisplay].size.width)
        [super update:dt];
}

- (void)execute {
    ccTime minInterval;
    if (gameData.currentLevel < 7)
        minInterval = -1;
    else {
        minInterval = 11.0f - gameData.currentLevel;
        minInterval = (minInterval < 1.0f ? 1.0f : minInterval);
    }
	GreenHole *greenHole = [[GreenHole alloc] initWithGame:game sproutZombiesInterval:minInterval size:size];
	greenHole.sprite.position = ccp([Display sharedDisplay].size.width + greenHole.sprite.size.width / 2 - [Display sharedDisplay].scrollX,
									50.0f + rand() % (int)([Display sharedDisplay].size.height - greenHole.sprite.size.height - 86.0f));
	[levelGenerator.elements iterateOrRemove:^BOOL(id entry) {
		LevelElementGenerator *levelElement = entry;
		if (!([levelElement class] == [BuildingGenerator class] || [levelElement class] == [BlackHoleGenerator class]))
			return NO;
		if (CGRectIntersectsRect(levelElement.lastRect, [greenHole collidRect])) {
			CGPoint pos = greenHole.sprite.position;
			CGRect elementRect = levelElement.lastRect;
			pos.x = elementRect.origin.x + elementRect.size.width;
			greenHole.sprite.position = pos;
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
    [generatedElements addEntry:greenHole];
	[game.interactiveElements addEntry:greenHole];
    [greenHole release];

	[super execute];
}

- (ccTime)getTimeToNext {
	CGFloat minFrequency = 23.0f - (gameData.currentLevel - 5) * 2.0f;
	NSInteger randomValue = 50.0f - (gameData.currentLevel - 5) * 5;
	minFrequency = (minFrequency < 4.0f ? 4.0f : minFrequency);
	randomValue = randomValue < 2.0f ? 2.0f : randomValue;
	return minFrequency + (ccTime)(rand() % randomValue) / 10.0f;
}

- (void)levelPassed:(NSNotification *)note {
	size += 0.1;
	size = (size > 1.0f ? 1.0f : size);
}

- (NSRange)levelRange {
	return NSMakeRange(5, 424242);
}

@end
