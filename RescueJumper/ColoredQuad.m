//
//  ColoredQuad.m
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ColoredQuad.h"

#import "cocos2d.h"

@implementation ColoredQuad

@synthesize color, rect;

- (id)initWithRect:(CGRect)_rect color:(ccColor4B)_color {
    
    if (self = [super init]) {
        rect = _rect;
        color = _color;
        vertices[0] = rect.origin;
        vertices[1] = ccp(rect.origin.x * CC_CONTENT_SCALE_FACTOR(),
                          (rect.origin.y + rect.size.height) * CC_CONTENT_SCALE_FACTOR());
        vertices[2] = ccp((rect.origin.x + rect.size.width) * CC_CONTENT_SCALE_FACTOR(),
                          rect.origin.y * CC_CONTENT_SCALE_FACTOR());
        vertices[3] = ccp((rect.origin.x + rect.size.width) * CC_CONTENT_SCALE_FACTOR(),
                          (rect.origin.y + rect.size.height) * CC_CONTENT_SCALE_FACTOR());
        
        colors[0] = color;
        colors[1] = color;
        colors[2] = color;
        colors[3] = color;
    }
    return self;
    
}

- (void)draw {
    [super draw];
    
    drawPoly(vertices, colors, 4, YES);
}

void drawPoly( const CGPoint *poli, const ccColor4B *colors, NSUInteger numberOfPoints, BOOL closePolygon )
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	//glDisableClientState(GL_COLOR_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
    glVertexPointer(2, GL_FLOAT, 0, poli);
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei) numberOfPoints);
	
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	// restore default state
	//glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
}

@end
