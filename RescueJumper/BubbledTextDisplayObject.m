//
//  BubbledTextDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/13/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BubbledTextDisplayObject.h"

#import "BubbledLabelBMFont.h"

@implementation BubbledTextDisplayObject

- (id)initWithFont:(NSString *)fntFile anchor:(CGPoint)_anchor text:(NSString *)text {
	
	if (self = [super init]) {
		for (int i = 0; i < n; ++i) {
			node[i] = [[BubbledLabelBMFont alloc] initWithFntFile:fntFile text:text];
		}
		self.anchor = _anchor;
		size = node[0].contentSize;
	}
	return self;
}

- (void)setString:(NSString *)_string {
	for (int i = 0; i < n; ++i) {
		[((BubbledLabelBMFont *)node[i]) setText:_string];
	}
}

- (void)setOpacity:(GLubyte)_opacity {
	opacity = _opacity;
	for (int i = 0; i < n; ++i) {
		if (mainScreen == i || mainScreen < 0)
			[((BubbledLabelBMFont *)node[i]) setOpacity:opacity];
		else
			[((BubbledLabelBMFont *)node[i]) setOpacity:opacity / 3.0f];
	}
}

- (void)setColor:(ccColor3B)_color {
	color = _color;
	for (int i = 0; i < n; ++i) {
		[((BubbledLabelBMFont *)node[i]) setColor:color];
	}
}

@end
