//
//  ScoreHighLightManager.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/28/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ccTypes.h"

@class ChainList;

@class ScoreHighlightItem;

@interface ScoreHighLightManager : NSObject {
	
	ChainList *scoresHighlightItems;
	
	NSUInteger player;
	
}

- (id)initWithPlayer:(NSUInteger)_player;
- (void)update:(ccTime)dt;
- (void)addScoreHightLight:(ScoreHighlightItem *)item;
- (void)purge;

@end
