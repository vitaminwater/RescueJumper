//
//  Bonus.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "InteractiveElement.h"

#import "cocos2d.h"

#import "DisplayObject.h"

#import "Bipede.h"

#import "Game.h"
#import "PlayerData.h"

@implementation InteractiveElement

@synthesize sprite;
@synthesize toDelete;
@synthesize size;

- (id)initWithGame:(Game *)_game {
    
    if (self = [super init]) {
        game = _game;
        toDelete = NO;
    }
    return self;
    
}

- (void)update:(ccTime)dt {
	if (!sprite.visible)
		return;
	self.sprite.position = ccpAdd(self.sprite.position, ccp(Vx * dt, Vy * dt));
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - self.size.width / 2,
					  sprite.position.y - self.size.height / 2,
					  self.size.width, self.size.height);
}

- (void)dealloc {
    self.sprite = nil;
    [super dealloc];
}

@end
