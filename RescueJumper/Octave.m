//
//  Octave.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 5/23/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Octave.h"

#import "OctaveMovement.h"
#import "NeutralOctaveMovement.h"
#import "ZombieMovement.h"

#import "Scores.h"

#import "Display.h"

@implementation Octave

- (NSUInteger)getNode {
	return OTHER_BIPEDE;
}

- (NSObject<Movement> *)getNormalMovement {
	return [[[OctaveMovement alloc] initWithBipede:self game:game] autorelease];
}

- (NSObject<Movement> *)getNeutralMovement {
	return [[[NeutralOctaveMovement alloc] initWithBipede:self game:game] autorelease];
}

- (NSObject<Movement> *)getZombieMovement {
	return [[[ZombieMovement alloc] initWithBipede:self game:game] autorelease];
}

@end
