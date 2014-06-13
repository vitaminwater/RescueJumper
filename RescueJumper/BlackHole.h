//
//  BlackHole.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/14/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ContactElement.h"

@class ParticleDisplayObject;

@interface BlackHole : ContactElement {
	
	ParticleDisplayObject *particles;
	
}

- (id)initWithGame:(Game *)_game size:(CGFloat)_size;

- (void)swallowBipede:(Bipede *)bipede;
- (void)panickBipede:(Bipede *)bipede;

@end
