//
//  LevelElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelElementGenerator.h"

#import "Game.h"

#import "LevelGenerator.h"

#import "BaseGameElement.h"

@implementation LevelElementGenerator

@synthesize levelGenerator;
@synthesize generatedElements;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super init]) {
		timeToNext = 1000000;
		game = _game;
        gameData = _gameData;
        generatedElements = [[ChainList alloc] initWithAddCallbacks:@selector(elementAdded:) removeCallBack:@selector(elementRemoved:) delegate:self retainObjs:NO];
        if ([self respondsToSelector:@selector(levelPassed:)])
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelPassed:) name:LEVEL_PASSED object:nil];
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	timeToNext -= dt;
	if ([self canTrigger]) {
		[self execute];
	}
}

- (BOOL)canTrigger {
    return timeToNext <= 0;
}

- (void)execute {
    timeToNext = [self getTimeToNext];
}

- (void)removeGeneratedElement:(id)generatedElement {
    [generatedElements iterateOrRemove:^BOOL(id entry) {
        return generatedElement == entry;
    } removeOnYES:YES exit:YES];
}

- (NSRange)levelRange {
	return NSMakeRange(1, 424242);
}

- (ccTime)getTimeToNext {
	return 1000000;
}

- (CGRect)lastRect {
    if (![generatedElements count])
        return CGRectMake(0, 0, 0, 0);
	return [(BaseGameElement *)[generatedElements lastInserted] collidRect];
}

- (void)elementAdded:(BaseGameElement *)gameElement {
    gameElement.delegate = self;
}

- (void)elementRemoved:(BaseGameElement *)gameElement {
    gameElement.delegate = nil;
}

- (void)gameElementRemoved:(BaseGameElement *)gameElement {
    [generatedElements iterateOrRemove:^BOOL(id entry) {
        return entry == gameElement;
    } removeOnYES:YES exit:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [generatedElements release];
	[super dealloc];
}

@end
