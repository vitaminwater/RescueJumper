//
//  EasyShipElement.h
//  RescueJumper
//
//  Created by Constantin on 8/11/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelElementGenerator.h"
#import "Ship.h"

@class BipedeAddTimePicker;

@interface ShipGenerator : LevelElementGenerator<ShipDelegate> {
    
    BipedeAddTimePicker *timePicker;
	ccTime penalty;
    
}

- (BOOL)hasBlockingShip;

@end
