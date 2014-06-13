//
//  CoinElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CoinGenerator.h"

#import "cocos2d.h"
#import "CoinBonus.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Display.h"
#import "DisplayObject.h"

@implementation CoinGenerator

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		timeToNext = 1.0;
        value = 1.0f;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	[super update:dt];
}

- (void)execute {
	CoinBonus *bonus = [[CoinBonus alloc] initWithGame:game value:value];
	bonus.sprite.position = ccp([Display sharedDisplay].size.width + bonus.size.width / 2 - [Display sharedDisplay].scrollX,
								50.0f + rand() % (int)([Display sharedDisplay].size.height - bonus.sprite.size.height - 86));
	[game.interactiveElements addEntry:bonus];
    [bonus release];
	[super execute];
}

- (ccTime)getTimeToNext {
	return 1.0f;
}

- (void)levelPassed:(NSNotification *)note {
    value = 1.0f + (CGFloat)gameData.currentLevel / 7.8f;
    value = value > 4 ? 4 : value;
}

@end
