//
//  MotherShipElement.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelElementGenerator.h"

@class MotherShip;

@interface MotherShipGenerator : LevelElementGenerator {
	
	MotherShip *motherShip;
	BOOL ended;
	NSUInteger minX;
	
}

@property(nonatomic, assign)NSUInteger minX;

@end
