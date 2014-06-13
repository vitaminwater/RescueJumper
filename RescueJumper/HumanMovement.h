//
//  Human.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bipede.h"

@interface HumanMovement : NSObject<Movement> {
	
	Game *game;
	Bipede *bipede;
	
	BOOL jumping;
	
	BOOL right;
	
}

@end
