//
//  BaseGameElement.m
//  RescueJumper
//
//  Created by Constantin on 8/12/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseGameElement.h"

#import "Game.h"

@implementation BaseGameElement

@synthesize delegate;
@synthesize player;

- (id)init {
    
    if (self = [super init]) {
        self.player = NEUTRAL_PLAYER;
    }
    return self;
    
}

- (CGRect)collidRect {
	return CGRectMake(0, 0, 0, 0);
}

- (void)dealloc {
    if (self.delegate)
		[self.delegate gameElementRemoved:self];
    [super dealloc];
}

@end
