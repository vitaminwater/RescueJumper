//
//  Neutral.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bipede.h"

@interface NeutralMovement : NSObject<Movement> {
	
	Game *game;
	Bipede *bipede;
	
	BOOL right;
	
}

@end
