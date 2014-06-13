//
//  ParticleDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/27/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ParticleDisplayObject.h"

@implementation ParticleDisplayObject

@synthesize angle;
@synthesize sourcePosition;

-(id)initParticleNode:(NSString *)file scale:(CGFloat)_scale {
	
	if (self = [super init]) {
        
        static NSMutableDictionary *particleCache = nil;
        
        if (!particleCache)
            particleCache = [[NSMutableDictionary dictionary] retain];
        
        NSDictionary *particleDict = [particleCache objectForKey:file];
        if (!particleDict) {
            NSString *fileName = [file stringByDeletingPathExtension];
            particleDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
            [particleCache setValue:particleDict forKey:file];
        }
		
		for (int i = 0; i < n; ++i) {
			node[i] = [[CCParticleSystemQuad alloc] initWithDictionary:particleDict];
			node[i].position = ccp(0, 0);
			((CCParticleSystemQuad *)node[i]).angleVar = 0;
			((CCParticleSystemQuad *)node[i]).scale = _scale;
		}
		
	}
	return self;
}

- (void)setSourcePosition:(CGPoint)_sourcePosition {
	for (int i = 0; i < n; ++i) {
		((CCParticleSystemQuad *)node[i]).sourcePosition = _sourcePosition;
	}
	sourcePosition = _sourcePosition;
}

- (void)setAngle:(CGFloat)_angle {
	angle = _angle;
	for (int i = 0; i < n; ++i) {
		((CCParticleSystemQuad *)node[i]).angle = angle;
	}
}

- (void)stop {
	for (int i = 0; i < n; ++i)
		[((CCParticleSystemQuad *)node[i]) stopSystem];
}

- (void)reset {
	for (int i = 0; i < n; ++i)
		[((CCParticleSystemQuad *)node[i]) resetSystem];
}

- (void)dealloc {
	[self stop];
	[super dealloc];
}

@end
