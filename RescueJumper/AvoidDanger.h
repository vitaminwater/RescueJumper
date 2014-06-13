//
//  AvoidDanger.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/12/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseBipedeAction.h"

@class BlackHole;

@interface AvoidDanger : BaseBipedeAction {
	
	CGPoint dangerPos;
	
	ccTime panicking;
	
}

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game dangerPos:(CGPoint)_dangerPos;

@end
