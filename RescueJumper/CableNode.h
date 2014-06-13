//
//  CableNode.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 6/26/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCNode.h"

@class Game;

@interface CableNode : CCNode {
	
	Game *game;
	NSUInteger player;
	
	CCTexture2D *wheelTex;
    
    NSInteger nPoints;
    CGPoint *points;
    uint32_t *colors;
    CGPoint *quads;
    CGPoint *texCoord;
	
}

- (id)initWithGame:(Game *)_game player:(NSUInteger)_player;
- (void)drawLines:(CGPoint *)points colors:(uint32_t *)colors numberOfPoints:(uint)numberOfPoints;
- (void)drawQuads:(CGPoint *)points texture:(CCTexture2D *)texture texCoord:(CGPoint *)texCoords numberOfPoints:(uint)numberOfPoints;

@end
