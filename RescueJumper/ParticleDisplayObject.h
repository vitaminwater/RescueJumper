//
//  ParticleDisplayObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/27/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "DisplayObject.h"

@class CCParticleSystemQuad;

@interface ParticleDisplayObject : DisplayObject {
	
	CCParticleSystemQuad *particles;
	
	CGFloat angle;
	CGPoint sourcePosition;
	
}

@property(nonatomic, assign)CGFloat angle;
@property(nonatomic, assign)CGPoint sourcePosition;

-(id)initParticleNode:(NSString *)file scale:(CGFloat)scale;
- (void)stop;
- (void)reset;

@end
