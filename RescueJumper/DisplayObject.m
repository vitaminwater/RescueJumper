//
//  DisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "DisplayObject.h"
#import "Display.h"

@implementation DisplayObject

@synthesize node;
@synthesize size;
@synthesize position;
@synthesize anchor;
@synthesize scale;
@synthesize scaleX;
@synthesize opacity;
@synthesize color;
@synthesize visible;
@synthesize rotation;
@synthesize mainScreen;
@synthesize borderColor;

- (id)init {
	
	if (self = [super init]) {
		scale = 1.0f;
		scaleX = 1.0f;
		opacity = 255.0f;
		color = ccWHITE;
		visible = YES;
		rotation = 0.0f;
		mainScreen = -1;
		anchor = CGPointMake(0.5, 0.5);
		n = [Display sharedDisplay].n;
		node = malloc(sizeof(CCNode *) * n);
		memset(node, 0, sizeof(CCNode *) * n);
	}
	return self;
	
}

- (void)addSubDisplayObject:(DisplayObject *)displayObject {
	for (int i = 0; i < n; ++i) {
		[node[i] addChild:displayObject.node[i]];
	}
}

- (void)setPosition:(CGPoint)_position {
	for (int i = 0; i < n; ++i) {
		node[i].position = _position;
	}
	position = _position;
}

- (void)setAnchor:(CGPoint)_anchor {
	anchor = _anchor;
	for (int i = 0; i < n; ++i) {
		node[i].anchorPoint = anchor;
	}
}

- (void)setScale:(CGFloat)_scale {
	scale = _scale;
	for (int i = 0; i < n; ++i) {
		node[i].scale = scale;
	}
}

- (void)setScaleX:(CGFloat)_scaleX {
	scaleX = _scaleX;
	for (int i = 0; i < n; ++i) {
		node[i].scaleX = scaleX;
	}
}

- (void)setVisible:(BOOL)_visible {
	visible = _visible;
	for (int i = 0; i < n; ++i) {
		node[i].visible = visible;
	}
}

- (void)setRotation:(CGFloat)_rotation {
	rotation = _rotation;
	for (int i = 0; i < n; ++i) {
		node[i].rotation = rotation;
	}
}

- (void)setMainScreen:(NSInteger)_mainScreen {
	mainScreen = _mainScreen;
	self.opacity = opacity;
}

- (void)dealloc {
	for (int i = 0; i < n; ++i) {
		if (!node[i])
			continue;
		[node[i] removeFromParentAndCleanup:YES];
		[node[i] release];
	}
	free(node);
	[super dealloc];
}

@end
