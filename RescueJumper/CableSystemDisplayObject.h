//
//  CableSystemDisplayObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 6/26/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "DisplayObject.h"

@class Game;

@interface CableSystemDisplayObject : DisplayObject {
	
	Game *game;
	
}

- (id)initWithGame:(Game *)_game;

@end
