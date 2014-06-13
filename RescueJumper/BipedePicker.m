//
//  BipedeBonusPicker.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedePicker.h"

#import "Game.h"

#import "Bipede.h"

@implementation BipedePicker

@synthesize nPendingBipedes;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {

	if (self = [super init]) {
		game = _game;
        gameData = _gameData;
        if ([self respondsToSelector:@selector(levelPassed:)])
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelPassed:) name:LEVEL_PASSED object:nil];
	}
	return self;

}

- (void)update:(ccTime)dt {
}

- (BOOL)canTrigger {
	return NO;
}

- (void)generateBipedes:(ChainList *)jumpBases {
	return;
}

- (NSRange)levelRange {
	return NSMakeRange(1, 424242);
}

- (Bipede *)createBipede:(JumpBase *)jumpBase {
    Bipede *bipede = [[Bipede alloc] initWithJumpBase:jumpBase player:NEUTRAL_PLAYER game:game];
    bipede.picker = self;
    [game.pnjs addEntry:bipede];
    [bipede release];
    return bipede;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
