//
//  BaseTutorial.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@class Game;
@class ChainList;
@class TextDisplayObject;
@class StaticDisplayObject;
@class TutorialMessage;
@class AnimatedNode;

@interface BaseTutorial : NSObject {

	Game *game;
	
	ChainList *tutorialHands;
	
	CGFloat scrollSpeed;
	
	CCMenu *endButtMenu;
    AnimatedNode *endButtSprite;
	BOOL endButtPressed;
    
    TutorialMessage *text;
	
	ccTime time;
}

- (id)initWithGame:(Game *)_game;
- (BOOL)canTrigger;
- (void)trigger;
- (BOOL)update:(ccTime)dt;
- (BOOL)toDelete;
- (void)end;

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;

- (void)showEndButton;
- (void)addTutorialHand:(CGPoint)from to:(CGPoint)to delay:(ccTime)delay;
- (void)showMessage:(NSString *)message;

@end
