//
//  HospitalElement.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelElementGenerator.h"

@class Hospital;

@interface HospitalGenerator : LevelElementGenerator {

	Hospital *hospital;
	BOOL waitNext;
	ccTime waitSince;
	NSUInteger minX;
	
}

@property(nonatomic, readonly)BOOL waitNext;
@property(nonatomic, readonly)ccTime waitSince;
@property(nonatomic, readonly)NSUInteger onBoard;
@property(nonatomic, assign)NSUInteger minX;

- (void)activate;

@end
