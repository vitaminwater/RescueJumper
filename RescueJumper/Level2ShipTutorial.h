//
//  Level2ShipTutorial.h
//  RescueJumper
//
//  Created by Constantin on 12/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseTutorial.h"

@class Ship;
@class BuildingPlateforme;

@interface Level2ShipTutorial : BaseTutorial {
    
    Ship *ship;
    BuildingPlateforme *building;
    BOOL done;
    
}

- (id)initWithGame:(Game *)_game ship:(Ship *)_ship building:(BuildingPlateforme *)_building;

@end
