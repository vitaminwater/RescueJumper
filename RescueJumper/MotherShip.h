//
//  MotherShip.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "JumpBase.h"

@class ParticleDisplayObject;
@class MissilLauncher;

@interface MotherShip : JumpBase {
	
	ParticleDisplayObject *particles[3];
	MissilLauncher *launcher;
	ccTime scanDelay;
    
    CGFloat shakeForce;
	
}

@end
