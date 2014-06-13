//
//  JumpToNext.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseBipedeAction.h"

#define JUMP_BASE_MEMORY 5

@class JumpBase;

@interface JumpToNext : BaseBipedeAction {

	JumpBase *lastJumpBases[JUMP_BASE_MEMORY];
	JumpBase *nextJumpBase;
	JumpBase *nextJumpBaseTmp;
	
	CGPoint from;
	CGPoint to;
	
	BOOL dir;
	
}

- (void)jumpToNext;
- (void)saveJumpBase:(JumpBase *)jumpBase;
- (BOOL)alreadySavedJumpBase:(JumpBase *)jumpBase;

@end
