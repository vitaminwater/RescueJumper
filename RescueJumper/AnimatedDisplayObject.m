//
//  AnimatedDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "AnimatedDisplayObject.h"
#import "AnimatedNode.h"

@implementation AnimatedDisplayObject

-(id)initAnimatedNode:(NSString *)defaultSprite defaultScale:(CGFloat)_scale anchor:(CGPoint)_anchor {
	
	if (self = [super init]) {
		
		currentActionObject = nil;
		repeating = NO;
		
		for (int i = 0; i < n; ++i) {
			node[i] = [[CCSprite spriteWithSpriteFrameName:defaultSprite] retain];
			node[i].scale = scale;
			node[i].position = ccp(0, 0);
		}
		self.anchor = _anchor;
		scale = _scale;
	}
	return self;
}

-(void)initAnim:(NSString *)animName n:(NSInteger)_n delay:(CGFloat)delay animPrefix:(NSString *)animPrefix {
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animName];
	if (animation == nil) {
		NSMutableArray *frames = [NSMutableArray array];
		for (int i = 1; i < _n + 1; ++i) {
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%i.png", animPrefix, i]];
			[frames addObject:frame];
		}
		animation = [CCAnimation animationWithFrames:frames delay:delay];
		[[CCAnimationCache sharedAnimationCache] addAnimation:animation name:animName];
	}
}

-(void)setAnim:(NSString *)name repeat:(BOOL)repeat {
	for (int i = 0; i < n; ++i)
		[node[i] stopAllActions];
	[currentActionObject release];
	currentActionObject = nil;
	repeating = repeat;
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:name];
	if (repeat) {
		for (int i = 0; i < n; ++i) {
			CCAction *action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
			[node[i] runAction:action];
		}
	} else {
		for (int i = 0; i < n; ++i) {
			CCAction *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
			[node[i] runAction:action];
			currentActionObject = [action retain];
		}
	}
	CGSize newSize = ((CCSpriteFrame *)[animation.frames objectAtIndex:0]).originalSizeInPixels;
	size = CGSizeMake(newSize.width / [UIScreen mainScreen].scale * fabs(node[0].scaleX), newSize.height / [UIScreen mainScreen].scale * fabs(node[0].scaleY));
}

-(BOOL)animEnded {
	return !repeating && [currentActionObject isDone];
}

-(void)reset {
	for (int i = 0; i < n; ++i)
		[node[i] stopAllActions];
	repeating = NO;
	[currentActionObject release];
	currentActionObject = nil;
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

- (void)dealloc {
	[currentActionObject release];
	currentActionObject = nil;
	[self reset];
	[super dealloc];
}

@end
