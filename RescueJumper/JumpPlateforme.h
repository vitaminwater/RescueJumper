//
//  JumpBase.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "JumpBase.h"

#define CAPACITY_PER_LEVEL 4

@class PartsManager;
@class StaticDisplayObject;

@interface JumpPlateforme : JumpBase {
	
	PartsManager *partsManager;
	
	NSUInteger level;
	
	StaticDisplayObject *noLink;
	
	ccTime timeUnlinked;
	
}

@property(nonatomic, readonly)NSUInteger level;

- (id)initWithPlayer:(NSUInteger)_player level:(NSUInteger)_level game:(Game *)_game;

+ (CGSize)sizeForLevel:(NSUInteger)_level;

@end
