//
//  AnimatedNode.h
//  RescueLander
//
//  Created by stant on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef ANIMATEDNODE_H
#define ANIMATEDNODE_H

#import "cocos2d.h"

@interface AnimatedNode : NSObject {
	
	NSMutableDictionary *animations;
	NSMutableDictionary *repeatAction;
	NSMutableDictionary *noRepeatAction;
	CCAction *currentActionObject;
	NSString *currentAction;
	BOOL repeating;
	
	CCSprite *sprite;
	
	CGSize size;

}

@property(nonatomic,readonly) CGSize size;
@property(nonatomic,readonly) CCAction *currentActionObject;
@property(nonatomic,readonly) CCSprite *sprite;

-(void)initAnimatedNode:(NSString *)nodeFile defaultSprite:(NSString *)defaultSprite defaultScale:(CGFloat)scale;
-(void)initAnim:(NSString *)animName n:(NSInteger)n delay:(CGFloat)delay animPrefix:(NSString *)animPrefix;
-(void)setAnim:(NSString *)name repeat:(BOOL)repeat;
-(void)reset;

@end

#endif