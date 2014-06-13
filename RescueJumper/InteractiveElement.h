//
//  Bonus.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

#import "JumpBase.h"

#import "BaseGameElement.h"

@class Game;
@class DisplayObject;

@interface InteractiveElement : BaseGameElement {
	
    DisplayObject *sprite;
    Game *game;
    CGSize size;
    
    CGFloat Vx;
    CGFloat Vy;
    
    BOOL toDelete;
    
}

@property(nonatomic, retain)DisplayObject *sprite;
@property(nonatomic, assign)BOOL toDelete;
@property(nonatomic, assign)CGSize size;

- (id)initWithGame:(Game *)_game;
- (void)update:(ccTime)dt;

@end
