//
//  GameStateActionLevelUp.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionLevelUp.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"
#import "TouchManager.h"
#import "ScoreHighLightManager.h"

#import "Display.h"

#import "LevelGenerator.h"
#import "HospitalGenerator.h"
#import "LevelUpMenuController.h"

#import "JumpBase.h"

#import "AppDelegate.h"

@implementation GameStateActionLevelUp

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if(self = [super initWithGame:_game gameData:_gameData]) {
		hospitalElement = [[HospitalGenerator alloc] initWithGame:game gameData:_gameData];
		[levelGenerator.elements addEntry:hospitalElement];
        [hospitalElement release];
		exit = NO;
		helperShown = NO;

		levelHelpers = [[NSArray arrayWithObjects:
						[NSArray arrayWithObjects:@"help-bh.png", nil],
						[NSArray arrayWithObjects:@"help-bonus-weight.png", nil],
						[NSArray arrayWithObjects:@"help-bonus-jump.png", nil],
						[NSArray arrayWithObjects:@"help-zombie.png", @"help-explose.png", nil],
						[NSArray arrayWithObjects:@"help-octave.png", nil], nil] retain];
	}
	return self;
	
}

- (int)getPriority {
	return [levelUpMenuControllers count] ? 4242 : 10;
}

- (BOOL)update:(float)dt {
	if (exit)
		return NO;
	if (hospitalElement.waitNext && ![levelUpMenuControllers count]) {
		NSUInteger n = 0;
		for (int i = 0; i < game.nPlayer; ++i) {
			n += game.playerData[i].bipedes.count;
		}
		if (n <= hospitalElement.onBoard) {
			[self showNext];
		} else if (!helperShown) {
			[[Display sharedDisplay] displayMessage:NSLocalizedString(@"HospitalText", @"")];
			helperShown = YES;
		}
	}
	
	for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
        [levelUpMenuController update:dt];
    }

	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] update:dt];

	[game processCollidRect:dt];
	[game processBipedes:dt];
	[game processJumpBases:dt];
	[levelGenerator update:dt];
	return !exit;
}

- (void)end:(BOOL)_interrupted {
    [hospitalElement activate];
    for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelUpMenuController];
    }
    [levelUpMenuControllers release];
}

- (BOOL)canTrigger {
	return (gameData.timeLeft == 0 && gameData.timeForNext != 0);
}

- (NSObject<Action> *)trigger {
	exit = NO;
	helperShown = NO;
	__block NSUInteger minX = 0;
	[game.jumpBases iterateOrRemove:^BOOL(id entry) {
		JumpBase *jumpBase = entry;
		CGRect lastRect = [jumpBase collidRect];
		if (minX < lastRect.origin.x + lastRect.size.width)
			minX = lastRect.origin.x + lastRect.size.width;
		return NO;
	} removeOnYES:NO exit:NO];
	hospitalElement.minX = minX + 20;
	[[Display sharedDisplay] displayMessage:NSLocalizedString(@"EndLevelText", @"")];
	return [super trigger];
}

- (void)showNext {
	gameData.currentLevel++;
    levelUpMenuControllers = [[NSMutableArray array] retain];
    game.muteMusicFader = YES;
	for (int i = 0; i < game.nPlayer; ++i) {
		LevelUpMenuController *levelUpMenuController = [[LevelUpMenuController alloc] initWithGame:game gameData:gameData player:i delegate:self levelHelpers:([levelHelpers count] > gameData.currentLevel - 2 ? [levelHelpers objectAtIndex:gameData.currentLevel - 2] : nil)];
		[(AppDelegate *)[UIApplication sharedApplication].delegate showMenu:levelUpMenuController player:i];
        [levelUpMenuControllers addObject:levelUpMenuController];
        [levelUpMenuController release];
	}
	
	//[TestFlight passCheckpoint:[NSString stringWithFormat:@"PASS_LEVEL %d", gameData.currentLevel]];
}

- (void)startNextLevel:(id)sender {
    if (exit)
        return;
	[[Display sharedDisplay] displayMessage:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Level", @""), gameData.currentLevel]];
	gameData.timeLeft = gameData.timeForNext;
    gameData.currentLevelTotalTime = gameData.timeForNext;
	gameData.timeForNext = 0;
	game.scrollSpeed = 50;
	[hospitalElement activate];
    [[NSNotificationCenter defaultCenter] postNotificationName:LEVEL_PASSED object:nil];
	for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
        NSUInteger index = [levelUpMenuControllers indexOfObject:levelUpMenuController];
		game.playerData[index].currentClockGuysSaved = 0;
        [game.scoreHighLightManager[index] purge];
		[(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelUpMenuControllers[index]];
	}
    [levelUpMenuControllers release];
    levelUpMenuControllers = nil;
	exit = YES;
    
    if ([SimpleAudioEngine sharedEngine].isBackgroundMusicPlaying) {
        game.muteMusicFader = NO;
        if (gameData.currentLevelTotalTime < 40)
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music_speed.mp3" loop:YES];
        else
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3" loop:YES];
    }
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	if (levelUpMenuControllers[0] != nil)
		return NO;
	return [game.touchManager[player] touchBegan:touch withEvent:event];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[game.touchManager[player] touchMoved:touch withEvent:event];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[game.touchManager[player] touchEnded:touch withEvent:event];
}

- (void)dealloc {
	for (LevelUpMenuController *levelUpMenuController in levelUpMenuControllers) {
		[(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelUpMenuController];
	}
	[levelHelpers release];
	[super dealloc];
}

@end
