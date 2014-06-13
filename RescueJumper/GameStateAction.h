//
//  GameState.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Actioner.h"

#import "ccTypes.h"

@class Game;

@interface GameStateAction : NSObject<Action> {
	
	Game *game;
	
}

- (id)initWithGame:(Game *)_game;

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;

@end
