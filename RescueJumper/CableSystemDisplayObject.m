//
//  CableSystemDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 6/26/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CableSystemDisplayObject.h"

#import "CableNode.h"

#import "Game.h"

#import "Display.h"


@implementation CableSystemDisplayObject

- (id)initWithGame:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		for (int i = 0; i < [Display sharedDisplay].n; ++i) {
			node[i] = [[CableNode alloc] initWithGame:game player:i];
		}
	}
	return self;
	
}

@end
