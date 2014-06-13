//
//  TextDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TextDisplayObject.h"
#import "cocos2d.h"

@implementation TextDisplayObject

@synthesize string;

- (id)initWithFont:(NSString *)fntFile anchor:(CGPoint)_anchor text:(NSString *)text {
	
	if (self = [super init]) {
		string = [text retain];
		for (int i = 0; i < n; ++i) {
			node[i] = [[CCLabelBMFont labelWithString:text fntFile:fntFile] retain];
			((CCLabelBMFont *)node[i]).string = text;
		}
		self.anchor = _anchor;
		size = node[0].contentSize;
	}
	return self;
}

- (void)setString:(NSString *)_string {
	for (int i = 0; i < n; ++i) {
		((CCLabelBMFont *)node[i]).string = _string;
	}
	[string release];
	string = [_string retain];
}

- (void)setOpacity:(GLubyte)_opacity {
	opacity = _opacity;
	for (int i = 0; i < n; ++i) {
		if (mainScreen == i || mainScreen < 0)
			[((CCLabelBMFont *)node[i]) setOpacity:opacity];
		else
			[((CCLabelBMFont *)node[i]) setOpacity:opacity / 3.0f];
	}
}

- (void)setColor:(ccColor3B)_color {
	color = _color;
	for (int i = 0; i < n; ++i) {
		[((CCLabelBMFont *)node[i]) setColor:color];
	}
}

- (void)dealloc {
	[string release];
	[super dealloc];
}

@end
