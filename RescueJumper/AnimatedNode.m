//
//  AnimatedNode.m
//  RescueLander
//
//  Created by stant on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimatedNode.h"

#import "cocos2d.h"

@implementation AnimatedNode

@synthesize size;
@synthesize currentActionObject;
@synthesize sprite;

-(id)init
{
	if ((self = [super init])) {
		animations = [[NSMutableDictionary alloc] init];
		repeatAction = [[NSMutableDictionary alloc] init];
		noRepeatAction = [[NSMutableDictionary alloc] init];
		currentAction = nil;
		currentActionObject = nil;
		repeating = NO;
	}
	return self;
}

-(void)initAnimatedNode:(NSString *)nodeFile defaultSprite:(NSString *)defaultSprite defaultScale:(CGFloat)scale
{
	sprite = [[CCSprite spriteWithSpriteFrameName:defaultSprite] retain];
	sprite.scale = scale;
	sprite.position = ccp(0, 0);
}

-(void)initAnim:(NSString *)animName n:(NSInteger)n delay:(CGFloat)delay animPrefix:(NSString *)animPrefix
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animName];
	if (animation == nil) {
		NSMutableArray *frames = [NSMutableArray array];
		for (int i = ([animName compare:@"stand4"] ? 1 : 4 ); i < n + 1; ++i) {
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%i.png", animPrefix, i]];
			[frames addObject:frame];
		}
		animation = [CCAnimation animationWithFrames:frames delay:delay];
		[[CCAnimationCache sharedAnimationCache] addAnimation:animation name:animName];
	}
	[animations setObject:animation forKey:animName];
}

-(void)setAnim:(NSString *)name repeat:(BOOL)repeat
{
	CCAction *action;
	if (currentActionObject != nil){
		[sprite stopAction:currentActionObject];
		[currentAction release];
		currentAction = nil;
		[currentActionObject release];
		currentActionObject = nil;
	}
	repeating = repeat;
	[currentAction release];
	currentAction = [name retain];
	if (repeat) {
		action = [repeatAction valueForKey:currentAction];
		if(action == nil) {
			action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[animations objectForKey:name] restoreOriginalFrame:NO]];
			[repeatAction setObject:action forKey:name];
		}
	} else {
		action = [noRepeatAction valueForKey:currentAction];
		if (action == nil) {
			action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:[animations objectForKey:name] restoreOriginalFrame:NO] times:1];
			[noRepeatAction setObject:action forKey:name];
		}
	}
	currentActionObject = [action retain];
	[sprite runAction:action];
	size = CGSizeMake(sprite.contentSize.width * fabs(sprite.scaleX), sprite.contentSize.height * fabs(sprite.scaleY));
}

-(void)reset {
	[animations removeAllObjects];
	[repeatAction removeAllObjects];
	[noRepeatAction removeAllObjects];
}

-(void)dealloc
{
	[self reset];
	[animations release];
	[repeatAction release];
	[noRepeatAction release];
	[currentAction release];
	currentAction = nil;
	[currentActionObject release];
	currentActionObject = nil;
	if (sprite.parent)
		[sprite.parent removeChild:sprite cleanup:YES];
	[sprite release];
	[super dealloc];
}

@end
