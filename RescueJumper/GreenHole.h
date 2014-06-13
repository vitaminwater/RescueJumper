//
//  GreenHole.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/23/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ContactElement.h"

@class ParticleDisplayObject;

@interface GreenHole : ContactElement {
	
	ParticleDisplayObject *particles;
    
    ccTime timeToSproutAZombie;
    ccTime minInterval;
	
}

- (id)initWithGame:(Game *)_game sproutZombiesInterval:(ccTime)_minInterval size:(CGFloat)_size;

- (void)transformBipede:(Bipede *)bipede;
- (void)panickBipede:(Bipede *)bipede;

@end
