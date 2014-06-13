//
//  GameStateActionIntro.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionSurvivalIntro.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "TopBarSurvivalStats.h"

#import "LevelGenerator.h"

#import "AppDelegate.h"
#import "LevelUpMenuController.h"

#import "GameStateActionPlaying.h"
#import "GameStateActionLevelUp.h"
#import "GameStateActionEndTimeOut.h"
#import "GameStateActionEndAllDead.h"
#import "GameStateActionSurvivalTutorial.h"

#import "BaseGameButton.h"
#import "ShipGameButton.h"
#import "TourelleGameButton.h"

#import "JumpPlateforme.h"

#import "Bipede.h"

@implementation GameStateActionSurvivalIntro

- (id)initWithGame:(Game *)_game {
	
	if (self = [super initWithGame:_game]) {
		done = NO;
		levelHelpers = [[NSArray arrayWithObjects:@"help-duplicate.png", @"help-bonus-time.png", @"help-fullship.png", nil] retain];
	}
	return self;
	
}

- (int)getPriority {
	return 4242;
}

- (BOOL)update:(float)dt {
	for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
        [levelUpMenuController update:dt];
    }
	[game processCollidRect:dt];
	[game processBipedes:dt];
	[game processJumpBases:dt];
	return !done;
}

- (void)end:(BOOL)interrupted {
}

- (BOOL)canTrigger {
	return !done;
}

- (NSObject<Action> *)trigger {
    [gameData release];
    gameData = [[SurvivalGameData alloc] init];
    for (int i = 0; i < game.nPlayer; ++i) {
        TopBarSurvivalStats *topStat = [[TopBarSurvivalStats alloc] initWithGame:game gameData:gameData player:i];
        [[Display sharedDisplay].screens[i] setTopStat:topStat];
        [topStat release];
    }
    levelUpMenuControllers = [[NSMutableArray array] retain];
	for (int i = 0; i < game.nPlayer; ++i) {
		LevelUpMenuController *levelUpMenuController = [[LevelUpMenuController alloc] initWithGame:game gameData:gameData player:i delegate:self levelHelpers:levelHelpers];
		[(AppDelegate *)[UIApplication sharedApplication].delegate showMenu:levelUpMenuController player:i];
        [levelUpMenuControllers addObject:levelUpMenuController];
	}
	return [super trigger];
}

- (void)startNextLevel:(id)sender {
    for (int i = 0; i < game.nPlayer; ++i) {
        BaseGameButton *tmp = [[ShipGameButton alloc] initWithGame:game gameData:gameData player:i];
        [game.buttons addEntry:tmp];
        [tmp release];
        
        tmp = [[TourelleGameButton alloc] initWithGame:game gameData:gameData player:i];
        [game.buttons addEntry:tmp];
        [tmp release];
    }
    
	for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelUpMenuController];
	}
    [levelUpMenuControllers release];
    levelUpMenuControllers = nil;
	done = YES;
	[[Display sharedDisplay] displayMessage:NSLocalizedString(@"TextIntro", @"")];
    
    [game.gameStateActioner addAction:[[[GameStateActionPlaying alloc] initWithGame:game gameData:gameData] autorelease]];
    [game.gameStateActioner addAction:[[[GameStateActionLevelUp alloc] initWithGame:game gameData:gameData] autorelease]];
    [game.gameStateActioner addAction:[[[GameStateActionEndTimeOut alloc] initWithGame:game gameData:gameData] autorelease]];
    [game.gameStateActioner addAction:[[[GameStateActionEndAllDead alloc] initWithGame:game gameData:gameData] autorelease]];
    if (game.nPlayer == 1)
        [game.gameStateActioner addAction:[[[GameStateActionSurvivalTutorial alloc] initWithGame:game gameData:gameData] autorelease]];
    
    for (int i = 0; i < game.nPlayer; ++i) {
        JumpPlateforme *first = [[JumpPlateforme alloc] initWithPlayer:i level:1 game:game];
        first.sprite.position = ccp([Display sharedDisplay].size.width - first.size.width / 2 - 200, [Display sharedDisplay].size.height / 2);
        [first activate];
        first.isDeletable = NO;
        [game.jumpBases addEntry:first];
        [first release];
        
        Bipede *firstBipede = [[Bipede alloc] initWithJumpBase:first player:i game:game];
        [game.playerData[i].bipedes addEntry:firstBipede];
        [firstBipede release];
        
        [game.playerData[i] addStat:STAT_LEVEL n:1 pts:0];
    }
    game.muteMusicFader = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:LEVEL_PASSED object:nil];
}

- (void)dealloc {
	for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelUpMenuController];
	}
	[levelUpMenuControllers release];
	[levelHelpers release];
    [gameData release];
	[super dealloc];
}

@end
