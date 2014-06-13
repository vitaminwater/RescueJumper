//
//  ScoreHighLightManager.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/28/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ScoreHighLightManager.h"

#import "cocos2d.h"

#import "Display.h"
#import "Screen.h"
#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"

#import "ChainList.h"

#import "BipedeBonus.h"

#import "ScoreHighlightItem.h"

@implementation ScoreHighLightManager

- (id)initWithPlayer:(NSUInteger)_player {
	
	if (self = [super init]) {
		scoresHighlightItems = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:)
												   removeCallBack:@selector(dummy:)
														 delegate:self];
        
		player = _player;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	[scoresHighlightItems iterateOrRemove:^BOOL(id entry) {
		ScoreHighlightItem *current = entry;
        return ![current update:dt];
	} removeOnYES:YES exit:NO];
}

- (void)addScoreHightLight:(ScoreHighlightItem *)item {
    [scoresHighlightItems addEntry:item];
}

- (void)purge {
    [scoresHighlightItems iterateOrRemove:^BOOL(id entry) {
        return YES;
    } removeOnYES:YES exit:NO];
}

- (void)dummy:(id)entry {}

- (void)dealloc {
	[scoresHighlightItems release];
	[super dealloc];
}

@end
