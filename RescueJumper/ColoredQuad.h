//
//  ColoredQuad.h
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCNode.h"

@interface ColoredQuad : CCNode {
    
    CGPoint vertices[4];
    ccColor4B colors[4];
    
}

@property(nonatomic, assign)ccColor4B color;
@property(nonatomic, assign)CGRect rect;

- (id)initWithRect:(CGRect)_rect color:(ccColor4B)_color;

@end
