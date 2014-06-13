//
//  MovingEntity.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ccTypes.h"

#import "MBDACenter.h"

@class Actioner;
@class Game;
@class JumpBase;
@class AnimatedDisplayObject;
@class BipedePicker;
@class BipedeBonus;
@class Bipede;
@class ParticleDisplayObject;
@class BubbledTextDisplayObject;

@protocol Movement <NSObject>

- (id)initWithBipede:(Bipede *)bipede game:(Game *)_game;
- (void)initAnims;
- (void)initActions;
- (void)update;
- (void)run:(BOOL)right;
- (void)walk:(BOOL)right;
- (void)stand:(BOOL)right;
- (void)jumpUp:(BOOL)right;
- (void)jump:(BOOL)right;
- (void)land:(BOOL)right;
- (void)speak:(BOOL)right;
- (void)fear:(BOOL)right;
- (void)happy:(BOOL)right;

- (void)onSaved;
- (void)onKilled;
- (NSUInteger)getWeight;

- (NSString *)savedSprite;

@property(nonatomic, readonly)BOOL right;

@end

@interface Bipede : NSObject {
	
	Game *game;
	
	Actioner *actioner;
	
	JumpBase *currentJumpBase;
    
    BipedePicker *picker;
	
	CGFloat Vx;
	CGFloat Vy;
	
	NSInteger player;
	
	BOOL saved;
	BOOL dead;
	
	AnimatedDisplayObject *sprite;
	
	BOOL converting;
	
	BipedeBonus *bonus;
	
	NSObject<Movement> *movement;
	
	ParticleDisplayObject *particles;
	
	BubbledTextDisplayObject *message;
	ccTime messageTime;
	CGFloat messageScale;
	
}

@property(nonatomic, assign)BOOL saved;
@property(nonatomic, assign)BOOL dead;

@property(nonatomic, readonly)NSInteger player;
@property(nonatomic, retain)JumpBase *currentJumpBase;

@property(nonatomic, assign)BipedePicker *picker;

@property(nonatomic, assign)CGFloat Vx;
@property(nonatomic, assign)CGFloat Vy;

@property(nonatomic, readonly)AnimatedDisplayObject *sprite;

@property(nonatomic, readonly)Actioner *actioner;

@property(nonatomic, assign)BOOL converting;

@property(nonatomic, retain)BipedeBonus *bonus;

@property(nonatomic, retain)NSObject<Movement> *movement;

- (id)initWithJumpBase:(JumpBase *)jumpBase player:(NSInteger)_player game:(Game *)_game;
- (void)initAnims;
- (void)update:(ccTime)dt;
- (void)convertToPlayer:(NSUInteger)_player;
- (CGFloat)getWaitingTime;
- (void)sizeChanged;
- (void)currentJumpBaseDeleted;
- (void)displayMessage:(NSString *)_message scale:(CGFloat)scale;
- (void)displayMessage:(NSString *)_message scale:(CGFloat)scale color:(ccColor3B)color;
- (BOOL)isDisplayingMessage;

- (NSUInteger)getNode;
- (NSObject<Movement> *)getNormalMovement;
- (NSObject<Movement> *)getNeutralMovement;
- (NSObject<Movement> *)getZombieMovement;

@end
