//
//  BuildingElement.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelElementGenerator.h"

#import "ccTypes.h"

@class BipedeGenerator;

@interface BuildingGenerator : LevelElementGenerator {
	
	BipedeGenerator *bipedeGenerator;
    
    ccTime firstDelay;
    
}

@property(nonatomic, readonly)BipedeGenerator *bipedeGenerator;

@end
