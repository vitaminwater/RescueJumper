//
//  BipedeAddTimePicker.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedePicker.h"

@interface BipedeAddTimePicker : BipedePicker {
	
    @public
	ccTime currentlyOnField[3];
    
    @private
    ccTime timeGiven;

    ccTime interval;
    ccTime waitTime;
	
}

- (ccTime)levelGivenTime;
- (BOOL)timeToGive;

@end
