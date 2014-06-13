//
//  SkyNode.m
//  RescueJumper
//
//  Created by Constantin on 12/12/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SkyNode.h"

#import "cocos2d.h"

#import "ChainList.h"

#import "Display.h"

#define COLOR_STEPS 12

@interface SkyNode()

- (ccColor4B)colorForPos:(CGPoint)pos;

@end

@implementation SkyNode

static ccColor4B steps[COLOR_STEPS] = {(ccColor4B){255, 255, 103, 255}, (ccColor4B){255, 255, 103, 255}, (ccColor4B){255, 255, 103, 255}, (ccColor4B){214, 255, 188, 255}, (ccColor4B){134, 255, 176, 255}, (ccColor4B){41, 72, 106, 255}, (ccColor4B){8, 16, 33, 255}, (ccColor4B){7, 25, 39, 255}, (ccColor4B){7, 25, 39, 255}, (ccColor4B){41, 72, 106, 255}, (ccColor4B){41, 72, 106, 255}, (ccColor4B){41, 72, 106, 255}};

static CGFloat maxDist = 0;

@synthesize sunPos;

- (id)initWithRect:(CGRect)_rect nPieces:(NSUInteger)_nPieces {
    
    if (self = [super init]) {
        rect = _rect;
        nPieces = _nPieces;
        
        maxDist = 1500 * CC_CONTENT_SCALE_FACTOR() * 1500 * CC_CONTENT_SCALE_FACTOR();
        
        bigStars = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
        
        bigStarsBatch = [CCSpriteBatchNode batchNodeWithFile:@"atlas_stars.png"];

        moon = [CCSprite spriteWithSpriteFrameName:@"moon3.png"];
        moon.anchorPoint = ccp(0, 1);
        moon.position = ccp(rect.origin.x + 50, rect.origin.y + rect.size.height - 50);
        [bigStarsBatch addChild:moon];
        
        CGRect moonRect = CGRectMake(moon.position.x - 50, moon.position.y - moon.contentSize.height, moon.contentSize.width + 100, moon.contentSize.height);
        for (int i = 0; i < 40; ++i) {
            CCSprite *star;
            star = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"star0%d.png", (i % 6) + 1]];
            do {
                star.position = ccp(rect.origin.x + (rand() % (int)rect.size.width), rect.origin.y + (rand() % (int)rect.size.height));
            } while (CGRectContainsPoint(moonRect, star.position));
            [bigStarsBatch addChild:star];
            [bigStars addEntry:star];
        }
        
        [self addChild:bigStarsBatch];
        
        numberOfSkyVertices = nPieces * nPieces * 2 + nPieces * 2 + (nPieces - 1) * 2;
        skyVertices = malloc(sizeof(GLuShortPoint) * numberOfSkyVertices);
        skyColors = malloc(sizeof(ccColor4B) * numberOfSkyVertices);
        
        numberOfStars = 300;
        starsVertices = malloc(sizeof(GLuShortPoint) * numberOfStars);
        starsColors = malloc(sizeof(ccColor4B) * numberOfStars);
        [self updateStars];
    }
    return self;
    
}

- (void)dummy:(id)entry {}

- (void)updateVertices {
    [self updateSkyVertices];
}

- (void)updateSkyVertices {
    NSUInteger currentV = 0;
    CGFloat xOffset = rect.size.width / nPieces;
    CGFloat yOffset = rect.size.height / nPieces;
    for (int y = 0; y < nPieces; ++y) {
        for (int x = 0; x <= nPieces; ++x) {
            skyVertices[currentV] = (GLuShortPoint){(rect.origin.x + x * xOffset) * CC_CONTENT_SCALE_FACTOR(),
                (rect.origin.y + y * yOffset) * CC_CONTENT_SCALE_FACTOR()};
            skyColors[currentV] = [self colorForPos:ccp(skyVertices[currentV].x, skyVertices[currentV].y)];
            ++currentV;
            
            skyVertices[currentV] = (GLuShortPoint){(rect.origin.x + x * xOffset) * CC_CONTENT_SCALE_FACTOR(),
                (rect.origin.y + (y + 1) * yOffset) * CC_CONTENT_SCALE_FACTOR()};
            skyColors[currentV] = [self colorForPos:ccp(skyVertices[currentV].x, skyVertices[currentV].y)];
            ++currentV;
        }
        if (y < nPieces - 1) {
            GLuShortPoint repeated = skyVertices[currentV - 1];
            skyVertices[currentV] = repeated;
            skyColors[currentV] = ccc4(0, 0, 0, 0);
            ++currentV;
            
            repeated.x = 0;
            skyVertices[currentV] = repeated;
            skyColors[currentV] = ccc4(0, 0, 0, 0);
            ++currentV;
        }
    }
}

- (void)updateStars {
    CGRect moonRect = CGRectMake(moon.positionInPixels.x - 50 * CC_CONTENT_SCALE_FACTOR(), moon.positionInPixels.y - moon.contentSizeInPixels.height, moon.contentSizeInPixels.width + 100 * CC_CONTENT_SCALE_FACTOR(), moon.contentSizeInPixels.height);
    for (int i = 0; i < numberOfStars; ++i) {
        do {
            starsVertices[i] = (GLuShortPoint){(rect.origin.x + rand() % (int)rect.size.width) * CC_CONTENT_SCALE_FACTOR(), (rect.origin.y + rand() % (int)rect.size.height) * CC_CONTENT_SCALE_FACTOR()};
        } while (CGRectContainsPoint(moonRect, ccp(starsVertices[i].x, starsVertices[i].y)));
    }
}

- (void)updateColors {
    for (int i = 0; i < numberOfSkyVertices; ++i) {
        skyColors[i] = [self colorForPos:ccp(skyVertices[i].x, skyVertices[i].y)];
    }
    [self updateStarsColors];
}

- (void)updateStarsColors {
    for (int i = 0; i < numberOfStars; ++i) {
        CGFloat sunDist = ccpLengthSQ(ccpSub(sunPos, ccp(starsVertices[i].x, starsVertices[i].y)));
        CGFloat step = sunDist / maxDist * 155 + (rand() % 100);
        step = step > 255 ? 255 : step;
        starsColors[i] = ccc4(255, 255, 255, step);
    }
    
    [bigStars iterateOrRemove:^BOOL(id entry) {
        CCSprite *star = entry;
        CGFloat sunDist = ccpLengthSQ(ccpSub(sunPos, ccp(star.positionInPixels.x, star.positionInPixels.y)));
        CGFloat step = sunDist / maxDist * 255 + (rand() % 50);
        step = step > 255 ? 255 : step;
        star.opacity = step;
        return NO;
    } removeOnYES:NO exit:NO];
}

- (ccColor4B)colorForPos:(CGPoint)pos {
    CGFloat sunDist = ccpLengthSQ(ccpSub(sunPos, pos));
    CGFloat step = sunDist / maxDist * COLOR_STEPS;
    step = step > COLOR_STEPS - 1 ? COLOR_STEPS - 1 : step;
    NSUInteger istep = floorf(step);
    CGFloat stepAdvance = step - istep;
    
    ccColor4B result = ccc4(steps[istep].r / 2 + (CGFloat)(steps[istep + 1].r / 2 - steps[istep].r / 2) * stepAdvance,
                            steps[istep].g / 2 + (CGFloat)(steps[istep + 1].g / 2 - steps[istep].g / 2) * stepAdvance,
                            steps[istep].b / 2 + (CGFloat)(steps[istep + 1].b / 2 - steps[istep].b / 2) * stepAdvance, 255);
    
    return result;
}

- (void)draw {
    [super draw];
	[self drawSky];
    [self drawStars];
}

- (void)drawSky {
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	//glDisableClientState(GL_COLOR_ARRAY);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
    glVertexPointer(2, GL_SHORT, 0, skyVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, skyColors);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei) numberOfSkyVertices);
	
    //glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	// restore default state
	//glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

- (void)drawStars {
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	//glDisableClientState(GL_COLOR_ARRAY);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glPointSize(2);
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, starsColors);
    glVertexPointer(2, GL_SHORT, 0, starsVertices);
    
    glDrawArrays(GL_POINTS, 0, (GLsizei) numberOfStars);
	
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	// restore default state
	//glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

- (void)setSunPos:(CGPoint)_sunPos {
    sunPos = ccpMult(_sunPos, CC_CONTENT_SCALE_FACTOR());
}

- (void)dealloc {
    free(skyColors);
    free(skyVertices);
    
    free(starsColors);
    free(starsVertices);
    
    [bigStars release];
    [super dealloc];
}

@end
