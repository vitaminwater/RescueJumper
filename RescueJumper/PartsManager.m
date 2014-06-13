//
//  PartsManager.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/4/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "PartsManager.h"

@implementation PartsManager

- (id)initWithNParts:(NSUInteger)_nParts partSize:(NSUInteger)_partSize partsHP:(NSUInteger)_partsHP {
	
	if (self = [super init]) {
		nParts = _nParts;
		partSize = _partSize;
		partsHP = malloc(sizeof(CGFloat) * nParts);
		for (int i = 0; i < nParts; ++i) {
			partsHP[i] = _partsHP;
		}
	}
	return self;
	
}

- (BOOL)hit:(NSUInteger)position force:(CGFloat)force resultingBlock:(void(^)(NSUInteger position, NSUInteger size))resultingBlock {
	NSUInteger partHit = position / partSize;
	partHit = partHit >= nParts ? nParts - 1 : partHit;
	partsHP[partHit] -= force;
	partsHP[partHit] = partsHP[partHit] < 0 ? 0 : partsHP[partHit];
	if (partsHP[partHit])
		return NO;
	if (partHit != 0)
		resultingBlock(0, partHit);
	if (partHit != nParts - 1)
		resultingBlock(partHit + 1, nParts - (partHit + 1));
	return YES;
}

- (void)dealloc {
	free(partsHP);
	[super dealloc];
}

@end
