//
//  CollidObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCNode.h"

#import "MBDACenter.h"

#import "BaseGameElement.h"

@class StaticDisplayObject;
@class Game;
@class Bipede;
@class PartsManager;
@class ProxyAim;

@interface CollidObject : BaseGameElement<MissilAim> {
	
	Game *game;
	StaticDisplayObject *sprite;
    PartsManager *partsManager;
    ProxyAim *aimObject;
	
	CGFloat Vx;
	CGFloat Vy;
	
	CGPoint from;
	CGPoint to;
	CGPoint position;
	BOOL reverse;
	BOOL mvt;
	BOOL breakable;
	NSUInteger size;
	
	ccTime totalTime;
	
}

@property(nonatomic, readonly)CGFloat Vx;
@property(nonatomic, readonly)CGFloat Vy;
@property(nonatomic, readonly)StaticDisplayObject *sprite;
@property(nonatomic, assign)CGPoint position;
@property(nonatomic, readonly)BOOL breakable;
@property(nonatomic, readonly)NSUInteger size;

- (id)initWithGame:(Game *)_game size:(NSUInteger)_size mvt:(BOOL)_mvt breakable:(BOOL)_breakable from:(CGPoint)_from to:(CGPoint)_to;
- (void)update:(ccTime)dt;
- (void)invertDir;
- (BOOL)checkBipede:(Bipede *)bipede collidRect:(CGRect)collidRect delta:(ccTime)dt;
- (BOOL)hit:(CGFloat)height force:(CGFloat)force;

@end
