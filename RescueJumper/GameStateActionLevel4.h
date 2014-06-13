//
//  GameStateActionLevel4.h
//  RescueJumper
//
//  Created by Constantin on 11/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@class Hospital;

@interface GameStateActionLevel4 : GameStateAction {
    
    Hospital *hospital;
    
}

- (id)initWithGame:(Game *)_game hospital:(Hospital *)_hospital;

@end
