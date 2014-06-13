//
//  Smoke.h
//  RescueLander
//
//  Created by stant on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __SMOKE_H
#define __SMOKE_H

#import "cocos2d.h"

@class StaticDisplayObject;

#define N_SMOKE 10

@interface Smoke : NSObject {
	
	CGPoint dir;
	CGFloat rot;
	
	StaticDisplayObject *sprite;
	
}

@property(nonatomic, readonly)StaticDisplayObject *sprite;

- (void)setDirection:(CGPoint)direction;
- (void)onEnterFrame:(ccTime)dt;

@end

@interface SmokeManager : NSObject
{
	Smoke **cache;
}

- (id)init;
- (void)update:(ccTime)dt;
- (Smoke *)getSmoke;
- (void)getSmoke:(CGPoint)direction pos:(CGPoint)pos;

@end


#endif