//
//  Physics.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Physics.h"

@implementation Physics

+ (BOOL)jumpFrom:(CGPoint)from to:(CGPoint)to result:(CGPoint *)result te:(double *)te {
	double tc;
	double delta;
	double overHeight = (to.y - from.y < 0 ? from.y : to.y) + 40;
	if (fabs(to.y - from.y) < 60)
		overHeight += fabs(to.x - from.x) / 10.0f;
	
	result->y = sqrtf(2.0f*NEWTON_G * (overHeight - from.y));
	tc = result->y / NEWTON_G;
	delta = powf(result->y, 2) - 4.0f*((-NEWTON_G/2) * -(to.y - from.y));
	if (delta > 0) {
		double te1 = (-result->y - sqrtf(delta)) / -NEWTON_G;
		double te2 = (-result->y + sqrtf(delta)) / -NEWTON_G;
		if (te1 >= tc)
			*te = te1;
		else
			*te = te2;
	} else if (!delta)
		*te = result->y / NEWTON_G;
	else
		return NO;
	result->x = (to.x - from.x) / *te;
	return YES;
}

@end
