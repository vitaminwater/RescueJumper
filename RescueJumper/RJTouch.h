//
//  RJTouch.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/3/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@class BorderedCCSprite;
@class JumpBase;
@class Game;

@interface RJTouch : NSObject {
	
	NSMutableArray *fromJumpBases;
	CGPoint fromTouchPos;
    
    JumpBase *currentJumpBase;
    CGPoint currentTouchPos;
    
    CGPoint realJumpBasePos;
    NSUInteger realJumpBaseLvl;
    
	BOOL isOK;
    BOOL didMove;
	
	Game *game;
	
	NSInteger player;
	
	UITouch *touch;
    
    CCSprite *pathSprite[5];
    BorderedCCSprite *jumpBaseSprite;
    
    ccTime time;
	
}

@property(nonatomic, readonly)CGPoint fromTouchPos;
@property(nonatomic, readonly)CGPoint currentTouchPos;

@property(nonatomic, readonly)BOOL cancelled;

@property(nonatomic, readonly)UITouch *touch;

- (id)initWithGame:(Game *)_game player:(NSInteger)_player batch:(CCSpriteBatchNode *)batch;

- (void)update:(ccTime)dt;

- (BOOL)touchBegan:(UITouch *)_touch withEvent:(UIEvent *)event;
- (void)touchMoved:(UITouch *)_touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)_touch withEvent:(UIEvent *)event;

- (JumpBase *)isInsideFromJB;

- (void)drawPath;

- (void)avoidOverLap;
//- (JumpBase *)findJumpBase:(CGPoint)newPos checkCanHaveNext:(BOOL)checkCanHaveNext;
- (JumpBase *)findNeutralJumpBase:(CGPoint)pos checkCanHaveNext:(BOOL)checkCanHaveNext limitDist:(BOOL)limitDist;
//- (JumpBase *)findNeutralJumpBaseFromBipedes:(CGPoint)pos;

@end
