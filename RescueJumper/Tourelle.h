//
//  Tourelle.h
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "InteractiveElement.h"

@class StaticDisplayObject;
@class MissilLauncher;

@interface Tourelle : InteractiveElement {
    
    StaticDisplayObject *gun;
    CGFloat angle;
    
    MissilLauncher *launcher;
    CGPoint launcherOffset;
    ccTime scanDelay;
    
    ccTime time;
    
    id lastAim;
}

- (id)initWithGame:(Game *)_game player:(NSUInteger)_player;

@end
