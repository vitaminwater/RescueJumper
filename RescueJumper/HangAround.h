//
//  HangAround.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseBipedeAction.h"

@interface HangAround : BaseBipedeAction {
	
	ccTime timeToNextAction;
	BOOL standing;
	
}

- (void)newChoice;

@end
