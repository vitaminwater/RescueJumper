//
//  BipedeJumpBaseLvlUpPicker.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedePicker.h"

@interface BipedeJumpBaseLvlUpPicker : BipedePicker {
	
    NSUInteger currentlyOnField;
    ccTime timeToNext;
    
}

@property(nonatomic, assign)NSUInteger currentlyOnField;

@end
