//
//  AnimatedDisplayObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "DisplayObject.h"

@interface AnimatedDisplayObject : DisplayObject {

	CCAction *currentActionObject;
	BOOL repeating;
	
}

-(id)initAnimatedNode:(NSString *)defaultSprite defaultScale:(CGFloat)_scale anchor:(CGPoint)_anchor;
-(void)initAnim:(NSString *)animName n:(NSInteger)n delay:(CGFloat)delay animPrefix:(NSString *)animPrefix;
-(void)setAnim:(NSString *)name repeat:(BOOL)repeat;
-(BOOL)animEnded;
-(void)reset;

@end
