//
//  BlackHoleElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BlackHoleGenerator.h"

#import "cocos2d.h"
#import "BlackHole.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Display.h"
#import "DisplayObject.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"
#import "GreenHoleGenerator.h"

@implementation BlackHoleGenerator

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
	BlackHole *blackHole = [[BlackHole alloc] initWithGame:game size:size];
	blackHole.sprite.position = ccp([Display sharedDisplay].size.width + blackHole.sprite.size.width / 2 - [Display sharedDisplay].scrollX,
									50.0f + rand() % (int)([Display sharedDisplay].size.height - blackHole.sprite.size.height - 86));
	
	[levelGenerator.elements iterateOrRemove:^BOOL(id entry) {
		LevelElementGenerator *levelElement = entry;
		if (!([levelElement class] == [BuildingGenerator class] || [levelElement class] == [GreenHoleGenerator class]))
			return NO;
		if (CGRectIntersectsRect(levelElement.lastRect, [blackHole collidRect])) {
			CGPoint pos = blackHole.sprite.position;
			CGRect elementRect = levelElement.lastRect;
			pos.x = elementRect.origin.x + elementRect.size.width;
			blackHole.sprite.position = pos;
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
	
    [generatedElements addEntry:blackHole];
	[game.interactiveElements addEntry:blackHole];
    [blackHole release];
	
	[super execute];
}

- (ccTime)getTimeToNext {
	CGFloat minFrequency = 23.0f - (gameData.currentLevel - 2) * 1.6f;
	NSInteger randomValue = 50.0f - (gameData.currentLevel - 2) * 5;
	minFrequency = (minFrequency < 4.0f ? 4.0f : minFrequency);
	randomValue = randomValue < 2.0f ? 2.0f : randomValue;
	return minFrequency + (ccTime)(rand() % randomValue) / 10.0f;
}

- (void)levelPassed:(NSNotification *)note {
	size += 0.1;
	size = (size > 1.0f ? 1.0f : size);
}

- (NSRange)levelRange {
	return NSMakeRange(2, 424242);
}

@end

