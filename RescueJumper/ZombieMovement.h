//
//  ZombieMovement.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bipede.h"

#import "MBDACenter.h"

@class ProxyAim;

@interface ZombieMovement : NSObject<Movement, MissilAim> {
	
	Game *game;
	Bipede *bipede;
    
    ProxyAim *aimObject;
	
	BOOL right;
	
	NSUInteger fromPlayer;
	
}

@end
