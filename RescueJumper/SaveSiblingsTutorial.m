//
//  SaveSiblingsTutorial.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SaveSiblingsTutorial.h"

#import "Display.h"
#import "TextDisplayObject.h"

#import "Game.h"
#import "PlayerData.h"

#import "ChainList.h"

#import "JumpBase.h"
#import "Bipede.h"

@implementation SaveSiblingsTutorial

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
        neutralJumpBase = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildingAdded:) name:BUILDING_ADDED object:nil];
	}
	return self;
	
}

- (BOOL)canTrigger {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SaveSiblingsTutorial"])
		return NO;
    if (!neutralJumpBase) {
        [game.jumpBases iterateOrRemove:^BOOL(id entry) {
            JumpBase *current = entry;
            if (current.type == JUMPBASE_BUILDING && [current.onBoard count] > 0) {
                neutralJumpBase = current;
                return YES;
            }
            return NO;
        } removeOnYES:NO exit:YES];
        return NO;
    }
    if (neutralJumpBase.lifeTime > 5.0f && [game.playerData[0].bipedes count] == 1 && ((Bipede *)[game.playerData[0].bipedes lastInserted]).currentJumpBase) {
        __block BOOL trigger = YES;
        [game.jumpBases iterateOrRemove:^BOOL(id entry) {
            JumpBase *current = entry;
            if ([current linkedTo:neutralJumpBase]) {
                trigger = NO;
                return YES;
            }
            return NO;
        } removeOnYES:NO exit:YES];
        return trigger;
    }
    return NO;
}

- (void)trigger {
    [super trigger];
    [self showMessage:NSLocalizedString(@"SurvivalSaveSiblingsTutorial", @"")];
    [self addTutorialHand:((Bipede *)[game.playerData[0].bipedes lastInserted]).currentJumpBase.sprite.position to:neutralJumpBase.sprite.position delay:1.0f];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SaveSiblingsTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toDelete {
	return (neutralJumpBase && neutralJumpBase.lifeTime >= 7.0f) || [game.playerData[0].bipedes count] > 1 || [[NSUserDefaults standardUserDefaults] boolForKey:@"SurvivalSaveSiblingsTutorial"];
}

- (void)end {
    [super end];
}

- (void)buildingAdded:(NSNotification *)note {
	neutralJumpBase = [note object];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
