//
//  StaticDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"
#import "StaticDisplayObject.h"

#import "BorderedCCSprite.h"

@implementation StaticDisplayObject

- (id)initSprite:(NSString *)img anchor:(CGPoint)_anchor isSpriteFrame:(BOOL)isSpriteFrame {
	
	if (self = [super init]) {
		for (int i = 0; i < n; ++i) {
			if (isSpriteFrame)
				node[i] = [[BorderedCCSprite spriteWithSpriteFrameName:img] retain];
			else
				node[i] = [[BorderedCCSprite spriteWithFile:img] retain];
		}
		self.anchor = _anchor;
		size = node[0].contentSize;
	}
	return self;
	
}

- (void)setOpacity:(GLubyte)_opacity {
	opacity = _opacity;
	for (int i = 0; i < n; ++i) {
		if (mainScreen == i || mainScreen < 0)
			[((CCSprite *)node[i]) setOpacity:opacity];
		else
			[((CCSprite *)node[i]) setOpacity:opacity / 3.0f];
	}
}

- (void)setColor:(ccColor3B)_color {
	color = _color;
	for (int i = 0; i < n; ++i) {
		[((CCSprite *)node[i]) setColor:color];
	}
}

- (void)setBorderColor:(ccColor3B)_borderColor {
    borderColor = _borderColor;
    for (int i = 0; i < n; ++i) {
        ((BorderedCCSprite *)node[i]).borderColor = _borderColor;
    }
}

- (void)dealloc {
	[super dealloc];
}

@end
