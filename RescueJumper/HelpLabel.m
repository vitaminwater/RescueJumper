//
//  HelpLabel.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HelpLabel.h"

#import "StaticDisplayObject.h"

#import "LevelElement.h"

#import "Display.h"

#import "HelpCenter.h"

@implementation HelpLabel

@synthesize sprite;
@synthesize holder;

- (id)initWithSpriteFrameName:(NSString *)frameName holder:(NSObject<HelpHolder> *)_holder {
	
	if (self = [super init]) {
		holder = _holder;
		sprite = [[StaticDisplayObject alloc] initSprite:frameName anchor:ccp(0.5, 0.0) isSpriteFrame:YES];
		sprite.position = [holder helpPosition];
		sprite.opacity = 0;
		opacity = 255;
		timeLeft = 8;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:FRONT z:0];
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	if (opacity) {
		sprite.position = [holder helpPosition];
		timeLeft -= dt;
		if (timeLeft <= 0)
			opacity = 0;
	}
	if (sprite.opacity != opacity)
		sprite.opacity += (sprite.opacity < opacity ? 5 : -5);
}

- (void)hide {
	opacity = 0;
}

- (CGRect)rect {
	return CGRectMake(sprite.position.x - sprite.size.width * sprite.anchor.x,
					  sprite.position.y - sprite.size.height * sprite.anchor.y,
					  sprite.size.width, sprite.size.height);
}

- (void)dealloc {
	[sprite release];
	[super dealloc];
}

@end
