//
//  ParallaxManager.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ParallaxManager.h"
#import "cocos2d.h"

#import "ScrollingDisplayObject.h"

#import "Display.h"


@implementation ParallaxManager

- (id)initWithImg:(NSString *)img offset:(CGFloat)offset speed:(CGFloat)_speed {
	
	if (self = [super init]) {
		speed = _speed;
		sprite = [[ScrollingDisplayObject alloc] initSprite:img anchor:ccp(0, 0.5f) isSpriteFrame:NO size:CGSizeMake([Display sharedDisplay].size.width, -1)];
		sprite.position = ccp(0, offset);
		[[Display sharedDisplay] addDisplayObject:sprite onNode:ROOTNODE z:-1];
	}
	return self;
	
}

- (void)update:(ccTime)dt scrollX:(CGFloat)scrollX {
	[sprite scrollTextureX:scrollX * speed * dt Y:0];
}

- (void)dealloc {
	[sprite release];
	[super dealloc];
}

@end
