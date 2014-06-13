//
//  TouchManager.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/10/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Game;
@class CCSprite;
@class ChainList;

@interface TouchManager : NSObject {
	
	ChainList *touches;
	
	Game *game;
	
	NSInteger player;
		
	ccTime time;
    
    CCSpriteBatchNode *batch;
	
}

- (id)initWithGame:(Game *)_game player:(NSInteger)_player;

- (void)update:(ccTime)dt;

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)cancelAllTouches;

@end
