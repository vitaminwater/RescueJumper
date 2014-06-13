//
//  GameStateActionLevel1.h
//  RescueJumper
//
//  Created by Constantin on 10/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@class BuildingPlateforme;

@interface GameStateActionLevel1 : GameStateAction {
    
    BuildingPlateforme *goalBuilding;
    
    ccTime time;
    
}

- (id)initWithGame:(Game *)_game goalBuilding:(BuildingPlateforme *)_goalBuilding;

@end
