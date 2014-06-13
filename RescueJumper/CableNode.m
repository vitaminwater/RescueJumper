//
//  CableNode.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 6/26/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "CableNode.h"

#import "cocos2d.h"

#import "Game.h"

#import "Display.h"

#import "JumpBase.h"
#import "StaticDisplayObject.h"

@implementation CableNode

- (id)initWithGame:(Game *)_game player:(NSUInteger)_player {
	
	if (self = [super init]) {
		game = _game;
		player = _player;
        nPoints = -1;
		wheelTex = [[[CCTextureCache sharedTextureCache] addImage:@"cable_wheel.png"] retain];
	}
	return self;
}

- (void)draw {
	[super draw];
    if (nPoints < [game.jumpBases count]) {
        
        if (nPoints > 0) {
            free(points);
            free(colors);
            free(quads);
            free(texCoord);
        }

        nPoints = [game.jumpBases count];
        points = malloc(sizeof(CGPoint) * nPoints * 6);
        colors = malloc(sizeof(uint32_t) * nPoints * 6);
        
        quads = malloc(sizeof(CGPoint) * nPoints * 6);
        texCoord = malloc(sizeof(CGPoint) * nPoints * 6);
    }
    __block NSUInteger currentBase = 0;
	
	CGSize screenSize = [Display sharedDisplay].size;
	
	[game.jumpBases iterateOrRemove:^BOOL(id entry) {
		JumpBase *jumpBase = entry;
		
		if (!(jumpBase.isCabled && (jumpBase.player == player || jumpBase.player == NEUTRAL_PLAYER)))
			return NO;
		
		points[currentBase * 6] = CGPointMake(jumpBase.sprite.position.x * CC_CONTENT_SCALE_FACTOR(), (screenSize.height - 35) * CC_CONTENT_SCALE_FACTOR());
		colors[currentBase * 6] = jumpBase.sprite.opacity << 24 | 0x004B6877;
		points[currentBase * 6 + 1] = CGPointMake(jumpBase.sprite.position.x * CC_CONTENT_SCALE_FACTOR(), (jumpBase.sprite.position.y + jumpBase.sprite.size.width / 2) * CC_CONTENT_SCALE_FACTOR());
		colors[currentBase * 6 + 1] = jumpBase.sprite.opacity << 24 | 0x00336D7E;
		
		points[currentBase * 6 + 2] = CGPointMake((jumpBase.sprite.position.x) * CC_CONTENT_SCALE_FACTOR(), (jumpBase.sprite.position.y + jumpBase.sprite.size.width / 2) * CC_CONTENT_SCALE_FACTOR());
		colors[currentBase * 6 + 2] = jumpBase.sprite.opacity << 24 | 0x00336D7E;
		points[currentBase * 6 + 3] = CGPointMake((jumpBase.sprite.position.x + jumpBase.sprite.size.width / 2) * CC_CONTENT_SCALE_FACTOR(), jumpBase.sprite.position.y * CC_CONTENT_SCALE_FACTOR());
		colors[currentBase * 6 + 3] = jumpBase.sprite.opacity << 24 | 0x004DA6C0;
		
		points[currentBase * 6 + 4] = CGPointMake(jumpBase.sprite.position.x * CC_CONTENT_SCALE_FACTOR(), (jumpBase.sprite.position.y + jumpBase.sprite.size.width / 2) * CC_CONTENT_SCALE_FACTOR());
		colors[currentBase * 6 + 4] = jumpBase.sprite.opacity << 24 | 0x00336D7E;
		points[currentBase * 6 + 5] = CGPointMake((jumpBase.sprite.position.x - jumpBase.sprite.size.width / 2) * CC_CONTENT_SCALE_FACTOR(), jumpBase.sprite.position.y * CC_CONTENT_SCALE_FACTOR());
		colors[currentBase * 6 + 5] = jumpBase.sprite.opacity << 24 | 0x004DA6C0;
		
		// Frst triangle
		quads[currentBase * 6] = CGPointMake(points[currentBase * 6].x - 10 * CC_CONTENT_SCALE_FACTOR(), points[currentBase * 6].y - 12 * CC_CONTENT_SCALE_FACTOR());
		texCoord[currentBase * 6] = CGPointMake(0.0, 1.0);

		quads[currentBase * 6 + 1] = CGPointMake(points[currentBase * 6].x + 14 * CC_CONTENT_SCALE_FACTOR(), points[currentBase * 6].y - 12 * CC_CONTENT_SCALE_FACTOR());
		texCoord[currentBase * 6 + 1] = CGPointMake(1.0, 1.0);

		quads[currentBase * 6 + 2] = CGPointMake(points[currentBase * 6].x - 10 * CC_CONTENT_SCALE_FACTOR(), points[currentBase * 6].y + 12 * CC_CONTENT_SCALE_FACTOR());
		texCoord[currentBase * 6 + 2] = CGPointMake(0.0, 0.0);

		// Sec triangle
		quads[currentBase * 6 + 3] = CGPointMake(points[currentBase * 6].x + 14 * CC_CONTENT_SCALE_FACTOR(), points[currentBase * 6].y - 12 * CC_CONTENT_SCALE_FACTOR());
		texCoord[currentBase * 6 + 3] = CGPointMake(1.0, 1.0);
		
		quads[currentBase * 6 + 4] = CGPointMake(points[currentBase * 6].x - 10 * CC_CONTENT_SCALE_FACTOR(), points[currentBase * 6].y + 12 * CC_CONTENT_SCALE_FACTOR());
		texCoord[currentBase * 6 + 4] = CGPointMake(0.0, 0.0);
		
		quads[currentBase * 6 + 5] = CGPointMake(points[currentBase * 6].x + 14 * CC_CONTENT_SCALE_FACTOR(), points[currentBase * 6].y + 12 * CC_CONTENT_SCALE_FACTOR());
		texCoord[currentBase * 6 + 5] = CGPointMake(1.0, 0.0);
		
		++currentBase;
		return NO;
	} removeOnYES:NO exit:NO];
	
	[self drawLines:points colors:colors numberOfPoints:currentBase * 6];
	[self drawQuads:quads texture:wheelTex texCoord:texCoord numberOfPoints:currentBase * 6];
}

- (void)drawLines:(CGPoint *)_points colors:(uint32_t *)_colors numberOfPoints:(uint)numberOfPoints {
	//layout of points [0] = origin, [1] = destination and so on

    glLineWidth(CC_CONTENT_SCALE_FACTOR());
	glVertexPointer(2, GL_FLOAT, 0, _points);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, _colors);
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY,
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glDrawArrays(GL_LINES, 0, numberOfPoints);
	
	// restore default state
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

- (void)drawQuads:(CGPoint *)_points texture:(CCTexture2D *)texture texCoord:(CGPoint *)texCoords numberOfPoints:(uint)numberOfPoints {
	
    glDisableClientState(GL_COLOR_ARRAY);
    
	glBindTexture(GL_TEXTURE_2D, texture.name);
	glVertexPointer(2, GL_FLOAT, 0, _points);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	glDrawArrays(GL_TRIANGLES, 0, numberOfPoints);
	
	glBindTexture(GL_TEXTURE_2D, 0);

    glEnableClientState(GL_COLOR_ARRAY);
}

- (void)dealloc {
	[wheelTex release];
    free(points);
    free(colors);
    free(quads);
    free(texCoord);
	[super dealloc];
}

@end
