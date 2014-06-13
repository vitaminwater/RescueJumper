//
//  ScoreLabelHighlightItem.m
//  RescueJumper
//
//  Created by Constantin on 8/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ScoreLabelHighlightItem.h"

#import "Display.h"
#import "Screen.h"

@implementation ScoreLabelHighlightItem

- (id)initWithPos:(CGPoint)_pos score:(NSInteger)score player:(NSUInteger)_player {
    
    if (self = [super init]) {
        scoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@%d", (score > 0 ? @"+" : @""), score] fntFile:[NSString stringWithFormat:@"burgley19%c.fnt", (score < 0 ? 'r' : 'g')]];
        scoreLabel.position = _pos;
        scoreLabel.scale = 2.0f + fabs(score) / 2000;
        scoreLabel.scale = scoreLabel.scale > 3.5 ? 3.5 : scoreLabel.scale;
        [[Display sharedDisplay].screens[_player].scrollNode addChild:scoreLabel];
    }
    return self;
    
}

- (BOOL)update:(ccTime)dt {
    if (scoreLabel.scale < 0.5)
        return NO;
    scoreLabel.scale -= dt * 1.5;
    scoreLabel.opacity = 255 - 150.0f * (1.0f - (scoreLabel.scale / 2.0f > 1.0f ? 1.0f : scoreLabel.scale / 2.0f));
    scoreLabel.position = ccpAdd(scoreLabel.position, ccp(0, 20 * dt));
    return YES;
}

- (void)dealloc {
    [scoreLabel removeFromParentAndCleanup:YES];
    [super dealloc];
}

@end
