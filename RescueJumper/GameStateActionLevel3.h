//
//  GameStateActionLevel3.h
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@class BuildingPlateforme;

@interface GameStateActionLevel3 : GameStateAction {
    
    BuildingPlateforme *goalBuilding;
    BuildingPlateforme *goalBuilding2;
    ccTime time;
    
}

- (id)initWithGame:(Game *)_game goalBuilding:(BuildingPlateforme *)_goalBuilding  goalBuilding2:(BuildingPlateforme *)_goalBuilding2;

@end
