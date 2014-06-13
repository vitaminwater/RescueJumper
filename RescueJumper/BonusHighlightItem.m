//
//  BonusHighlightItem.m
//  RescueJumper
//
//  Created by Constantin on 8/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BonusHighlightItem.h"

#import "Display.h"
#import "Screen.h"
#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"

#import "Bipede.h"

#import "BipedeBonus.h"

@implementation BonusHighlightItem

- (id)initWithSprite:(NSString *)_sprite start:(CGPoint)_start end:(CGPoint)_end scaleStart:(CGFloat)_scaleStart scaleEnd:(CGFloat)_scaleEnd duration:(ccTime)_duration delay:(ccTime)_delay player:(NSUInteger)_player {
    
    if (self = [super init]) {
        start = ccpSub(_start, ccp(-[Display sharedDisplay].scrollX, 0));
        end = _end;
        
        time = 0;
        duration = _duration;
        delay = _delay;
        
        scaleStart = _scaleStart;
        scaleEnd = _scaleEnd;

        sprite = [CCSprite spriteWithSpriteFrameName:_sprite];
        sprite.position = start;
        sprite.scale = scaleStart;
        sprite.opacity = 127;
        [[Display sharedDisplay].screens[_player].rootNode addChild:sprite];
    }
    return self;
    
}

- (BOOL)update:(ccTime)dt {
    if (delay > 0) {
        delay -= dt;
        return YES;
    }
    if (time == 1.0f)
        return NO;
    time += dt / duration;
    time = (time > 1.0f ? 1.0f : time);

    sprite.position = CGPointMake(start.x + (end.x - start.x) * time, start.y + (end.y - start.y) * time);
    sprite.scale = scaleStart + (scaleEnd - scaleStart) * time;
    sprite.opacity = 127 - 127.0f * time;
    return YES;
}

- (void)dealloc {
    [sprite removeFromParentAndCleanup:YES];
    [super dealloc];
}

@end
