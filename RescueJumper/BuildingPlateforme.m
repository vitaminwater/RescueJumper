//
//  BuildingPlateforme.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BuildingPlateforme.h"

#import "BuildingGenerator.h"

#import "Display.h"
#import "StaticDisplayObject.h"

@implementation BuildingPlateforme

- (id)initWithSprite:(NSString *)spriteName game:(Game *)_game isSpriteFrame:(BOOL)isSpriteFrame {
	
	if (self = [super initWithGame:_game]) {
		
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:spriteName anchor:ccp(0.5, 1.0) isSpriteFrame:isSpriteFrame];
		sprite = _sprite;
		size = sprite.size;
		
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BLOCK_BACK z:0];
		
		canHaveNext = YES;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
		
	}
	return self;
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - sprite.size.width / 2,
					  sprite.position.y - sprite.size.height,
					  sprite.size.width, sprite.size.height);
}

- (NSUInteger)type {
    return JUMPBASE_BUILDING;
}

- (void)dealloc {
	[super dealloc];
}

@end
