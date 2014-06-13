//
//  SwallowByBlackHole.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/15/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseBipedeAction.h"

@class BlackHole;

@interface SwallowByBlackHole : BaseBipedeAction {
	
	BlackHole *blackHole;
	CGFloat rotSpeed;
	
}

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game blackHole:(BlackHole *)_blackHole;

@end
