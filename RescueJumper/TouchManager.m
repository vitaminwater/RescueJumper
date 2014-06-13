//
//  TouchManager.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/10/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TouchManager.h"
#import "cocos2d.h"

#import "Display.h"
#import "Screen.h"
#import "DisplayObject.h"
#import "StaticDisplayObject.h"

#import "Game.h"

#import "JumpBase.h"

#import "CollidObject.h"

#import "RJTouch.h"

#import "Physics.h"

@implementation TouchManager

- (id)initWithGame:(Game *)_game player:(NSInteger)_player {
	if (self = [super init]) {
		
		touches = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
		
		time = 0;
		
		game = _game;
		player = _player;
		
		batch = [CCSpriteBatchNode batchNodeWithFile:@"atlas_human.png"];
		
		[[Display sharedDisplay].screens[player].pathNode addChild:batch];
	}
	return self;
}

- (void)update:(ccTime)dt {
	time += dt;
    [touches iterateOrRemove:^BOOL(id entry) {
        RJTouch *touch = entry;
        [touch update:dt];
        return NO;
    } removeOnYES:NO exit:NO];
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	RJTouch *newTouch = [[RJTouch alloc] initWithGame:game player:player batch:batch];
	if ([newTouch touchBegan:touch withEvent:event]) {
		[touches addEntry:newTouch];
		[newTouch release];
		return YES;
	}
	[newTouch release];
	return NO;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	[touches iterateOrRemove:^BOOL(id entry) {
		RJTouch *tmp = entry;
		if (tmp.touch == touch) {
			[tmp touchMoved:touch withEvent:event];
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[touches iterateOrRemove:^BOOL(id entry) {
		RJTouch *tmp = entry;
		if (tmp.touch == touch) {
			[tmp touchEnded:touch withEvent:event];
			return YES;
		}
		return NO;
	} removeOnYES:YES exit:YES];
}

- (void)cancelAllTouches {
	[touches iterateOrRemove:^BOOL(id entry) {
		return YES;
	} removeOnYES:YES exit:NO];
}

- (void)dummy:(id)sender {}

- (void)dealloc {
	[touches release];
	[super dealloc];
}

@end
