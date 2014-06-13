//
//  Smoke.m
//  RescueLander
//
//  Created by stant on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Smoke.h"
#import "StaticDisplayObject.h"
#import "Display.h"

@implementation Smoke

@synthesize sprite;

-(id)init
{
	if ( (self=[super init]) ) {
		sprite = [[StaticDisplayObject alloc] initSprite:@"smoke.png" anchor:ccp(0.5, 0.5) isSpriteFrame:NO];
		sprite.scale = 0.8;
		rot = ((double)(rand()%32)-16)/4;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BLOCK_BACK z:0];
	}
	return self;
}

-(void)setDirection:(CGPoint)direction
{
	dir = direction;
}

-(void)onEnterFrame:(ccTime)dt
{
	sprite.position = ccp(sprite.position.x + dir.x*3 + ((double)(rand()%32)-16)/3, sprite.position.y + dir.y*3 + ((double)(rand()%32)-16)/3);
	sprite.scale += 0.015;
	sprite.rotation += rot;
	sprite.opacity = 255 - (sprite.scale / 1.8)*255;
	if (sprite.scale >= 1.4) {
		sprite.visible = NO;
		sprite.scale = 0.8f;
		sprite.opacity = 255;
	}
}

-(void)dealloc
{
	[sprite release];
	[super dealloc];
}

@end

@implementation SmokeManager

-(id)init
{
	if ((self = [super init])) {
		cache = malloc(sizeof(Smoke *) * N_SMOKE);
		memset(cache, 0, sizeof(Smoke *) * N_SMOKE);
	}
	return self;
}

- (void)update:(ccTime)dt {
	for (int i = 0; i < N_SMOKE; ++i) {
		if (cache[i])
			[cache[i] onEnterFrame:dt];
	}
}

-(Smoke *)getSmoke
{
	for (int i = 0; i < N_SMOKE; ++i) {
		if (!cache[i]) {
			cache[i] = [[Smoke alloc] init];
			return cache[i];
		}
		if (!cache[i].sprite.visible)
			return cache[i];
	}
	return cache[rand() % N_SMOKE];
}

-(void)getSmoke:(CGPoint)direction pos:(CGPoint)pos
{	
	Smoke *newOne = [self getSmoke];
	newOne.sprite.position = pos;
	[newOne setDirection:direction];
	newOne.sprite.visible = YES;
}

-(void)dealloc
{
	for (int i = 0; i < N_SMOKE; ++i) {
		if (cache[i])
			[cache[i] release];
	}
	free(cache);
	[super dealloc];
}

@end

