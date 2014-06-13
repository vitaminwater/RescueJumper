//
//  Game.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCScene.h"
#import "CCTouchDelegateProtocol.h"

#import "ChainList.h"

#define NEUTRAL_PLAYER 2
#define ZOMBIE_PLAYER 3

@class Actioner;
@class LevelGenerator;
@class PlayerData;
@class Bipede;
@class JumpBase;
@class TouchManager;
@class ParallaxManager;
@class StaticDisplayObject;
@class CableSystemDisplayObject;
@class HelpScreen;
@class ScoreHighLightManager;
@class ScoreMenu;
@class SkyNode;

typedef enum _GameOrientation {
	PLAYER1,
	PLAYER2,
	SOLO
} GameOrientation;

typedef enum _GameButtonType {
    SHIP_BUTTON,
    TOURELLE_BUTTON
} GameButtonType;

@interface Game : CCScene {
	
	ChainList *pnjs;
	ChainList *jumpBases;
	ChainList *collidObjects;
    ChainList *interactiveElements;
    
    ChainList *buttons;
	
	CGFloat scrollSpeed;
	
	CGSize size;

	PlayerData **playerData;
	ScoreHighLightManager **scoreHighLightManager;
	
	ParallaxManager *parallaxManager[3];
    SkyNode *skyNodes[2];
	
	NSUInteger nPlayer;
	
	StaticDisplayObject *sky;
	
	CableSystemDisplayObject *cableSystem;
	
	Actioner *gameStateActioner;
	
	TouchManager **touchManager;
	
	BOOL muteMusicFader;
    
    ccTime gameTime;
	
}

@property(nonatomic, assign)CGFloat scrollSpeed;

@property(nonatomic, readonly)ChainList *pnjs;
@property(nonatomic, readonly)ChainList *jumpBases;
@property(nonatomic, readonly)ChainList *collidObjects;
@property(nonatomic, readonly)ChainList *interactiveElements;
@property(nonatomic, readonly)ChainList *buttons;

@property(nonatomic, readonly)PlayerData **playerData;
@property(nonatomic, readonly)ScoreHighLightManager **scoreHighLightManager;
@property(nonatomic, readonly)NSUInteger nPlayer;
@property(nonatomic, assign)NSUInteger nMissedUnits;

@property(nonatomic, readonly)Actioner *gameStateActioner;

@property(nonatomic, readonly)TouchManager **touchManager;

@property(nonatomic, assign)BOOL muteMusicFader;

@property(nonatomic, assign)ccTime gameTime;

- (id)initWithNPlayer:(NSUInteger)_nPlayer muted:(BOOL)muted;

- (void)processBipedes:(ccTime)dt;
- (void)processJumpBases:(ccTime)dt;
- (void)processCollidRect:(ccTime)dt;
- (BOOL)processBipede:(ccTime)dt bipede:(Bipede *)bipede;

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player;

- (void)jumpBaseAdded:(JumpBase *)jumpBase;
- (void)jumpBaseRemoved:(JumpBase *)jumpBase;

- (void)addScore:(CGFloat)score player:(NSUInteger)_player pos:(CGPoint)pos;
- (void)addScore:(CGFloat)score player:(NSUInteger)_player;

- (void)moveBipede:(Bipede *)bipede from:(NSInteger)from to:(NSInteger)to;

- (BOOL)addLeft:(NSInteger)addLeft buttonType:(GameButtonType)buttonType player:(NSUInteger)player;
- (NSUInteger)getLeft:(GameButtonType)buttonType player:(NSUInteger)player;

//- (void)cleanGame;

@end
