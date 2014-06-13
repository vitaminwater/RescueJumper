//
//  GoToZeBuvette.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/19/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseBipedeAction.h"

@interface GoToZeBuvette : BaseBipedeAction {
	
	CGRect collidRect;
	BOOL dir;
	BOOL waiting;
	ccTime happy;
	
}

@end
