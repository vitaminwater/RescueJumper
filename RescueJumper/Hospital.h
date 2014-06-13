//
//  Hospital.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "JumpBase.h"

@class StaticDisplayObject;
@class MissilLauncher;

@interface Hospital : JumpBase {
	
	StaticDisplayObject *front;
	ccTime scanDelay;
	
	MissilLauncher *launcher;
	
}

- (void)setPosition:(CGPoint)pos;

@end
