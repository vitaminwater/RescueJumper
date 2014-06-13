//
//  TutorialHand.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#define PATH_NODES 8

@class Game;

@interface TutorialHand : NSObject {
	
    Game *game;
    
	CGPoint *steps;
	NSUInteger nSteps;
	NSUInteger currentStep;
	ccTime stepWait;
	
	ccTime delay;
    ccTime time;
	
	CCSprite **stepSprites;
    CCSprite **pathSprites;
	
	CCSprite *shadow;
	CCSprite *hand;
	CGPoint handPos;
	CCNode *handNode;
	
}

- (id)initWithStart:(CGPoint)start end:(CGPoint)end delay:(ccTime)_delay game:(Game *)_game;

- (BOOL)update:(ccTime)dt;
- (void)updatePathsPosition;
- (void)updatePathsScale;

@end
