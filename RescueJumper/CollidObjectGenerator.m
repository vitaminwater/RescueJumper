//
//  CollidElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CollidObjectGenerator.h"

#import "cocos2d.h"

#import "CollidObject.h"
#import "Game.h"
#import "SurvivalGameData.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"

@implementation CollidObjectGenerator

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		timeToNext = 7;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    CGRect lastRect = [self lastRect];
    if (lastRect.origin.x + lastRect.size.width < -[Display sharedDisplay].scrollX + [Display sharedDisplay].size.width)
        [super update:dt];
}

- (void)execute {
	BOOL mvt = gameData.currentLevel >= 3 && (rand() % 2);
	BOOL breakable = !(gameData.currentLevel >= 6 && !(rand() % 5));
    NSUInteger size = (rand() % (gameData.currentLevel > 4 ? 4 : gameData.currentLevel)) + 1;
	CollidObject *collidObject = [[CollidObject alloc] initWithGame:game size:size mvt:mvt breakable:breakable from:CGPointMake(0, 200) to:CGPointMake(0, -200)];
	collidObject.position = ccp([Display sharedDisplay].size.width + collidObject.sprite.size.width / 2 - [Display sharedDisplay].scrollX,
									   [Display sharedDisplay].size.height - collidObject.sprite.size.height / 2 - (rand() % (int)([Display sharedDisplay].size.height - collidObject.sprite.size.height)));
	CGRect collidRect = CGRectMake(collidObject.position.x - collidObject.sprite.size.width / 2,
								   collidObject.position.y - 1000,
								   collidObject.sprite.size.width, 2000);
	[levelGenerator.elements iterateOrRemove:^BOOL(id entry) {
		LevelElementGenerator *levelElement = entry;
		if (!([levelElement isKindOfClass:[BuildingGenerator class]]))
			return NO;
		CGRect elementRect = levelElement.lastRect;
		if (CGRectIntersectsRect(elementRect, collidRect)) {
			CGPoint pos = collidObject.position;
			pos.x = elementRect.origin.x + elementRect.size.width + 10.0f;
			collidObject.position = pos;
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
	[generatedElements addEntry:collidObject];
	[game.collidObjects addEntry:collidObject];
    [collidObject release];
	[super execute];
}

- (ccTime)getTimeToNext {
    ccTime minFrequency = 8.5f - (ccTime)gameData.currentLevel * 0.5f;

    minFrequency = minFrequency < 1.5f ? 1.5f : minFrequency;
	minFrequency -= (minFrequency * 0.9f) * ((cosf(gameData.totalTime / 10.0f) + 1.0f) / 2.0f);
	
	return minFrequency;
}

@end
