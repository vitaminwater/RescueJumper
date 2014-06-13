//
//  GameStateActionTutorial.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateAction.h"

@class ChainList;
@class BaseTutorial;

@interface GameStateActionTutorial : GameStateAction {
	
	ChainList *tutorials;
	BaseTutorial *currentTutorial;
	
}

@property(nonatomic, readonly)ChainList *tutorials;

@end
