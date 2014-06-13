//
//  ScoreLabelHighlightItem.h
//  RescueJumper
//
//  Created by Constantin on 8/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ScoreHighlightItem.h"

@interface ScoreLabelHighlightItem : ScoreHighlightItem {
    
    CCLabelBMFont *scoreLabel;
    
}

- (id)initWithPos:(CGPoint)_pos score:(NSInteger)score player:(NSUInteger)_player;

@end
