//
//  GameStateActionPlaying.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionPlaying.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "SimpleAudioEngine.h"

#import "Game.h"
#import "Screen.h"
#import "SurvivalGameData.h"
#import "PlayerData.h"

#import "Bipede.h"

#import "TouchManager.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"
#import "ShipGenerator.h"
#import "CoinGenerator.h"
#import "CollidObjectGenerator.h"
#import "BlackHoleGenerator.h"
#import "GreenHoleGenerator.h"

@implementation GameStateActionPlaying

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
        [levelGenerator.elements addEntry:[[[BuildingGenerator alloc] initWithGame:game gameData:gameData] autorelease]];
		[levelGenerator.elements addEntry:[[[ShipGenerator alloc] initWithGame:game gameData:gameData] autorelease]];
		[levelGenerator.elements addEntry:[[[CoinGenerator alloc] initWithGame:game gameData:gameData] autorelease]];
		[levelGenerator.elements addEntry:[[[CollidObjectGenerator alloc] initWithGame:game gameData:gameData] autorelease]];
		[levelGenerator.elements addEntry:[[[BlackHoleGenerator alloc] initWithGame:game gameData:gameData] autorelease]];
		[levelGenerator.elements addEntry:[[[GreenHoleGenerator alloc] initWithGame:game gameData:gameData] autorelease]];
        showButtons = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelPassed:) name:LEVEL_PASSED object:nil];
	}
	return self;
	
}

- (int)getPriority {
	return 0;
}

- (BOOL)update:(float)dt {
	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] update:dt];

    if (!((NSUInteger)gameData.timeLeft % 5) && lastTimeAlert != gameData.timeLeft) {
        for (int i = 0; i < game.nPlayer; ++i) {
            [game.playerData[i].bipedes iterateOrRemove:^BOOL(id entry) {
                Bipede *bipede = entry;
                if (gameData.timeLeft <= 21 && gameData.timeLeft && (NSUInteger)gameData.timeLeft != lastTimeAlert && bipede.player < game.nPlayer && !((NSUInteger)gameData.timeLeft % 5) && ([game.playerData[bipede.player].bipedes count] < 10 || !(rand() % 2))) {
                    if ((NSUInteger)gameData.timeLeft)
                        [bipede displayMessage:[NSString stringWithFormat:@"%d sec", (NSUInteger)gameData.timeLeft] scale:1.0f color:ccc3(255, 100, 100)];
                    else {
                        if (gameData.timeForNext)
                            [bipede displayMessage:@"Lvl end !" scale:1.0f color:ccc3(255, 100, 100)];
                        else
                            [bipede displayMessage:@"TimeOut !" scale:1.0f color:ccc3(255, 100, 100)];
                    }
                }
                return NO;
            } removeOnYES:NO exit:NO];
        }
		lastTimeAlert = gameData.timeLeft;
    }
    if ((NSUInteger)gameData.timeLeft == 2 && !timeEndSound)
        timeEndSound = [[SimpleAudioEngine sharedEngine] playEffect:@"timeEnd.wav"];
    
	[self processTimers:dt];
	[game processCollidRect:dt];
	[game processBipedes:dt];
	[game processJumpBases:dt];
	[levelGenerator update:dt];
	return YES;
}

- (void)processTimers:(ccTime)dt {
	if (gameData.timeLeft > 0) {
		gameData.timeLeft -= dt;
		gameData.timeLeft = gameData.timeLeft < 0 ? 0 : gameData.timeLeft;
	}
	for (int i = 0; i < game.nPlayer; ++i)
		[game addScore:10.0f * dt player:i];
	gameData.totalTime += dt;
}

- (void)end:(BOOL)interrupted {
    [[SimpleAudioEngine sharedEngine] stopEffect:timeEndSound];
    timeEndSound = 0;
}

- (BOOL)canTrigger {
	return YES;
}

- (NSObject<Action> *)trigger{
	game.scrollSpeed = 50;
	return [super trigger];
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	return [game.touchManager[player] touchBegan:touch withEvent:event];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[game.touchManager[player] touchMoved:touch withEvent:event];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[game.touchManager[player] touchEnded:touch withEvent:event];
}

- (void)levelPassed:(NSNotification *)note {
    lastTimeAlert = 0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
