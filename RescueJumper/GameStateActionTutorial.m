//
//  GameStateActionTutorial.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionTutorial.h"

#import "ChainList.h"

#import "Game.h"
#import "TouchManager.h"

#import "BaseTutorial.h"

#import "SimpleAudioEngine.h"

@implementation GameStateActionTutorial

@synthesize tutorials;

- (id)initWithGame:(Game *)_game {
	
	if (self = [super initWithGame:_game]) {
		tutorials = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
	}
	return self;
	
}

- (int)getPriority {
	return 30;
}

- (BOOL)update:(float)dt {
	return [currentTutorial update:dt];
}

- (BOOL)canTrigger {
	[tutorials iterateOrRemove:^BOOL(id entry) {
		BaseTutorial *current = entry;
		
		if (!currentTutorial && [current canTrigger]) {
			currentTutorial = [current retain];
			[currentTutorial trigger];
			return YES;
		}
		return [current toDelete];
	} removeOnYES:YES exit:NO];
	return currentTutorial != nil;
}

- (NSObject<Action> *)trigger {
	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] cancelAllTouches];
	return [super trigger];
}

- (void)end:(BOOL)interrupted {
	[currentTutorial end];
	[currentTutorial release];
	currentTutorial = nil;
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{
	return [currentTutorial touchBegan:touch withEvent:event player:player];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{
	[currentTutorial touchMoved:touch withEvent:event player:player];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{
	[currentTutorial touchEnded:touch withEvent:event player:player];
}

- (void)dummy:(id)entry {}

- (void)dealloc {
	[currentTutorial release];
	[tutorials release];
	[super dealloc];
}

@end
