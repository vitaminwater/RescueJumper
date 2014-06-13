//
//  Display.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCScene.h"
#import "KSSingleton.h"

typedef enum _NODE_TYPE {
	
	NOSCALE,
	ROOTNODE,
	SCROLL,
	BACK,
	BONUS,
	BLOCK_BACK,
	BIPEDE,
	OTHER_BIPEDE,
	BLOCK_FRONT,
	SHIP,
	FRONT,
	TOPBAR
	
} NODE_TYPE;

@class Screen;
@class DisplayObject;
@class Game;

@interface Display : CCNode {
	
	Screen **screens;
	NSInteger n;
	
	CGFloat srollX;
	
	CGSize screenSize;
	CGSize size;
	
}

KS_SINGLETON_INTERFACE(Display)

@property(nonatomic, readonly)Screen **screens;
@property(nonatomic, readonly)NSInteger n;
@property(nonatomic, assign)CGFloat scrollX;
@property(nonatomic, readonly)CGSize screenSize;
@property(nonatomic, readonly)CGSize size;

+ (void)reset;
- (void)initScreens:(NSInteger)_n game:(Game *)game;
- (void)addDisplayObject:(DisplayObject *)displayObject onNode:(NODE_TYPE)node z:(NSInteger)z;
- (void)spawnParticleDict:(NSDictionary *)particleDict pos:(CGPoint)pos;
- (void)shakeScreens:(CGFloat)force;
- (void)displayMessage:(NSString *)_message;

+ (CGFloat)getDeviceReferenceWidth;

@end
