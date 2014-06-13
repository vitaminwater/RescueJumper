//
//  OctaveMovement.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 5/23/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bipede.h"

@interface OctaveMovement : NSObject<Movement> {
	
	Game *game;
	Bipede *bipede;
	
	BOOL jumping;
	
	BOOL right;
	
}

@end
