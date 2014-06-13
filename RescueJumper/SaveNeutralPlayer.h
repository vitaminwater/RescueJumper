//
//  SaveNeutralPlayer.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/15/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseBipedeAction.h"

@class JumpBase;

@interface SaveNeutralPlayer : BaseBipedeAction {
	
	Bipede *aim;
	Bipede *aimTmp;
	BOOL dir;
	
	ccTime waitingTime;
	BOOL waiting;
    
    JumpBase *ignoredJB;
	
}

@end
