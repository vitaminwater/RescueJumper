//
//  BaseGameButton.h
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "Game.h"

@class Game;
@class SurvivalGameData;

@interface BaseGameButton : NSObject<CCTargetedTouchDelegate> {
    
    CCSprite *sprite;
    CCLabelBMFont *nLeftLabel;
    
    Game *game;
    SurvivalGameData *gameData;
    NSUInteger player;
    
    ccTime time;
    
    NSUInteger nLeft;
    
    GameButtonType buttonType;
}

@property(nonatomic, readonly)CCSprite *sprite;
@property(nonatomic, readonly)GameButtonType buttonType;
@property(nonatomic, readonly)NSUInteger player;
@property(nonatomic, readonly)NSUInteger nLeft;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player sprite:(NSString *)_sprite;
- (BOOL)update:(ccTime)dt;
- (BOOL)execute;
- (void)addLeft:(NSUInteger)_addLeft;

@end
