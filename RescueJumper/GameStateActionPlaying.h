//
//  GameStateActionPlaying.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateSurvivalAction.h"

#import "SimpleAudioEngine.h"

@interface GameStateActionPlaying : GameStateSurvivalAction {
    
    NSUInteger lastTimeAlert;
    ALuint timeEndSound;
	
}

@end
