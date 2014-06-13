//
//  SkyNode.h
//  RescueJumper
//
//  Created by Constantin on 12/12/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CCNode.h"
#import "CCSprite.h"
#import "CCSpriteBatchNode.h"

@class ChainList;

typedef struct s_GLuShortPoint {
    
    GLushort x;
    GLushort y;
    
} GLuShortPoint;

@interface SkyNode : CCNode {
    
    CCSpriteBatchNode *bigStarsBatch;
    CCSprite *moon;
    ChainList *bigStars;
    
    GLuShortPoint *skyVertices;
    ccColor4B *skyColors;
    NSUInteger numberOfSkyVertices;
    NSUInteger nPieces;

    CGRect rect;
    
    GLuShortPoint *starsVertices;
    ccColor4B *starsColors;
    NSUInteger numberOfStars;
    
}

@property(nonatomic, assign)CGPoint sunPos;

- (id)initWithRect:(CGRect)_rect nPieces:(NSUInteger)nPieces;
- (void)updateVertices;
- (void)updateColors;
- (void)updateStarsColors;

@end
