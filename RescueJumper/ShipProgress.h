//
//  ShipProgress.h
//  RescueJumper
//
//  Created by Constantin on 10/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@interface ShipProgress : CCNode {
    
    CCSprite *bg;
    CCSprite *bar;
    CCSprite *ship;
    
    ccTime time;
    CGFloat progress;
    
    BOOL blowParticles;
    
}

@property(nonatomic, assign)CGFloat progress;

- (void)update:(ccTime)dt;

@end
