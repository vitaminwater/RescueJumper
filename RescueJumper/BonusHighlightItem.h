//
//  BonusHighlightItem.h
//  RescueJumper
//
//  Created by Constantin on 8/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ScoreHighlightItem.h"

@class BipedeBonus;

@interface BonusHighlightItem : ScoreHighlightItem {
    
    CCSprite *sprite;
    CGPoint start;
    CGPoint end;
    
    CGFloat scaleStart;
    CGFloat scaleEnd;
    
    ccTime time;
    ccTime duration;
    ccTime delay;
    
    NSUInteger level;
    
}

- (id)initWithSprite:(NSString *)_sprite start:(CGPoint)_start end:(CGPoint)_end scaleStart:(CGFloat)_scaleStart scaleEnd:(CGFloat)_scaleEnd duration:(ccTime)_duration delay:(ccTime)_delay player:(NSUInteger)_player;

@end
