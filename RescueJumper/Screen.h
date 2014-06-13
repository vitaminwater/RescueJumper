//
//  Screen.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@class Game;
@class ShipProgress;
@class ColoredQuad;

@protocol TopStat <NSObject>

- (void)update:(ccTime)dt;

@end

@interface Screen : CCNode<CCTargetedTouchDelegate> {

	CGSize realScreenSize;
	CGSize size;
	
	Game *game;
	NSUInteger player;
	
	CCNode *rootNode;
	CCNode *scrollNode;
	
	CCNode *backNode;
	CCSpriteBatchNode *bonusNode;
	CCNode *blockBackNode;
	CCSpriteBatchNode *bipedeNode;
	CCNode *otherBipedeNode;
	CCNode *blockFrontNode;
	CCNode *pathNode;
	CCSpriteBatchNode *shipNode;
	CCNode *frontNode;
	
	CCSprite *topStatBarBG;
    CCSprite *topStatBarBorder;
	
	CCSprite *playButt;
	CCSprite *pauseButt;
	UITouch *buttTouch;
	
	ColoredQuad *messageNode;
    CCLabelBMFont *message;
	ccTime messageDisplayTime;
	
	ccTime time;
    
    CGFloat shaker;
    
    CCNode<TopStat> *topStat;

}

@property(nonatomic, readonly)NSUInteger player;

@property(nonatomic, readonly)CCNode *rootNode;
@property(nonatomic, readonly)CCNode *scrollNode;
@property(nonatomic, readonly)CCNode *backNode;
@property(nonatomic, readonly)CCSpriteBatchNode *bonusNode;
@property(nonatomic, readonly)CCNode *blockBackNode;
@property(nonatomic, readonly)CCSpriteBatchNode *bipedeNode;
@property(nonatomic, readonly)CCNode *otherBipedeNode;
@property(nonatomic, readonly)CCNode *blockFrontNode;
@property(nonatomic, readonly)CCNode *pathNode;
@property(nonatomic, readonly)CCNode *frontNode;
@property(nonatomic, readonly)CCSpriteBatchNode *shipNode;

@property(nonatomic, readonly)CCSprite *topStatBarBG;

- (id)initWithScreenSize:(CGSize)_size player:(NSUInteger)_player game:(Game *)game;
- (void)shakeScreen:(CGFloat)force;
- (void)displayMessage:(NSString *)_message;
- (void)setTopStat:(CCNode<TopStat> *)_topStat;

@end
