//
//  GameState.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@implementation GameStateAction

- (id)initWithGame:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
	}
	return self;
	
}

- (BOOL)update:(float)dt {
	return NO;
}

- (void)end:(BOOL)interrupted {
}

- (void)onTurn {}

- (BOOL)canTrigger{return YES;}
- (NSObject<Action> *)trigger{return self;}
- (NSObject<Action> *)next{return nil;}
- (void)setNext:(NSObject<Action> *)nextArg{}
- (BOOL)blocker{return NO;}
- (int)getPriority{return 0;}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{return NO;}
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{}
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{}

- (void)dealloc {
	[super dealloc];
}

@end
