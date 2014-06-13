//
//  GameStateActionLevel2.h
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

#import "Ship.h"

@interface GameStateActionLevel2 : GameStateAction<ShipDelegate> {
    
    Ship *ship;
    BOOL full;
    ccTime time;
    
}

- (id)initWithGame:(Game *)_game ship:(Ship *)_ship;

@end
