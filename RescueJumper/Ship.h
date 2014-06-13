//
//  Ship.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/4/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCNode.h"
#import "JumpBase.h"

#define MAX_PASSENGERS 6

@class SmokeManager;
@class StaticDisplayObject;
@class TextDisplayObject;
@class Ship;

@protocol ShipDelegate <NSObject>

- (void)shipFull:(Ship *)ship player:(NSUInteger)player;
- (void)shipDestroyed:(Ship *)ship;

@end

@interface Ship : JumpBase {
    
    NSObject<ShipDelegate> *shipDelegate;
	
	NSInteger passengersLeft;
    NSInteger passengersIn;
		
	SmokeManager *smokeManager;
	
	StaticDisplayObject *top;
	TextDisplayObject *labelLeft;
	
	CGPoint position;
	
	CGFloat bipedeEffect;
    
    ALuint shipSound;
	
	BOOL exploding;
    BOOL leaving;
    
    CGFloat desiredVx;
	
}

@property(nonatomic, readonly)NSInteger passengersIn;
@property(nonatomic, assign)NSObject<ShipDelegate> *shipDelegate;
@property(nonatomic, assign)CGFloat desiredVx;

- (id)initWithGame:(Game *)_game position:(CGPoint)_position capacity:(NSUInteger)capacity;

- (void)leave;

@end
