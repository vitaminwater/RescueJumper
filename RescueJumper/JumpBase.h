//
//  JumpPlateForme.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ccTypes.h"
#import "SimpleAudioEngine.h"

#import "BaseGameElement.h"

@class JumpBase;
@class DisplayObject;
@class Game;
@class ChainList;
@class Bipede;

typedef struct s_JBlink {
	
	struct s_JBlink *next;
	NSUInteger player;
	CGPoint from;
	CGPoint to;
	JumpBase *base;
	ccTime lastJumper;
	
} JBlink;

#define color_array ((ccColor3B[]){ccc3(248,212,0), ccc3(192,143,191), ccc3(51,204,255), ccc3(153,204,0), ccc3(255,102,153)})

@interface JumpBase : BaseGameElement {
	
	Game *game;
	
	BOOL active;
	BOOL canJump;
	
	NSUInteger capacityMax;
	NSUInteger currentLoad;
	ChainList *onBoard;
	
	CGFloat Vx;
	CGFloat Vy;
	
	CGSize size;
	
	JBlink *linkedTo;
	JBlink *currentLink;
    NSUInteger nLinks;
	
    BOOL moveEntryPoints;
	BOOL canHaveNext;
	BOOL toDelete;
    BOOL isDeletable;
	
	BOOL isCabled;
	
	DisplayObject *sprite;
	
	ALuint screamSound;
	
	ccTime lifeTime;
    ccTime timeUnused;
    ccTime lastTouch;
	
	ChainList *partsLeft;
    
    NSUInteger color;
    
}

@property(nonatomic, assign)BOOL active;
@property(nonatomic, assign)BOOL canJump;

@property(nonatomic, assign)NSUInteger capacityMax;
@property(nonatomic, readonly)NSUInteger currentLoad;
@property(nonatomic, readonly)ChainList *onBoard;

@property(nonatomic, assign)CGFloat Vx;
@property(nonatomic, assign)CGFloat Vy;
@property(nonatomic, readonly)CGSize size;

@property(nonatomic, readonly)NSUInteger nLinks;

@property(nonatomic, assign)BOOL moveEntryPoints;
@property(nonatomic, assign)BOOL canHaveNext;
@property(nonatomic, assign)BOOL toDelete;
@property(nonatomic, assign)BOOL isDeletable;

@property(nonatomic, assign)BOOL isCabled;

@property(nonatomic, readonly)DisplayObject *sprite;

@property(nonatomic, assign)ccTime lifeTime;
@property(nonatomic, assign)ccTime timeUnused;
@property(nonatomic, assign)ccTime lastTouch;

@property(nonatomic, readonly)ChainList *partsLeft;

@property(nonatomic, assign)NSUInteger color;

- (id)initWithGame:(Game *)_game;

- (void)bipedeAdded:(Bipede *)bipede;
- (void)bipedeRemoved:(Bipede *)bipede;

- (void)addNextForPlayer:(NSUInteger)_player jumpBase:(JumpBase *)next fromPos:(CGPoint)from toPos:(CGPoint)to;
- (void)replaceNextForPlayer:(NSUInteger)_forPlayer from:(JumpBase *)from to:(JumpBase *)to;
- (JumpBase *)getNextForPlayer:(NSUInteger)pl from:(CGPoint *)from to:(CGPoint *)to waitTime:(CGFloat)waitTime;
- (void)removeNext:(JumpBase *)jumpBase;
- (void)activate;
- (void)blockedWall:(NSInteger)hitPoint force:(CGFloat)force;
- (void)jumpBaseRemoved:(NSNotification *)note;

- (BOOL)linksTo;
- (BOOL)linkedTo:(JumpBase *)jumpBase;

- (CGFloat)touchHeightAdded;

- (void)update:(ccTime)dt;

- (NSUInteger)type;

@end
