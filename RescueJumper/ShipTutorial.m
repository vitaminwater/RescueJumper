//
//  ShipTutorial.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ShipTutorial.h"

#import "Display.h"
#import "TextDisplayObject.h"
#import "StaticDisplayObject.h"

#import "Game.h"

#import "JumpBase.h"
#import "Ship.h"

#import "Bipede.h"

@implementation ShipTutorial

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
        ship = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shipAdded:) name:SHIP_ADDED object:nil];
	}
	return self;
	
}

- (BOOL)canTrigger {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShipTutorial"])
		return NO;
    if (ship && !ship.passengersIn && ship.lifeTime >= 5.0f) {
        __block BOOL trigger = YES;
        [game.jumpBases iterateOrRemove:^BOOL(id entry) {
            JumpBase *current = entry;
            if ([current linkedTo:ship]) {
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
    [game.jumpBases iterateOrRemove:^BOOL(id entry) {
        JumpBase *current = entry;
        if (current.active && current.canHaveNext && ![current linksTo]) {
            __block BOOL addHand = current.player < game.nPlayer;
            if (!addHand) {
                [current.onBoard iterateOrRemove:^BOOL(id entry) {
                    Bipede *current = entry;
                    if (current.player == PLAYER1) {
                        addHand = YES;
                        return YES;
                    }
                    return NO;
                } removeOnYES:NO exit:YES];
            }
            if (addHand)
                [self addTutorialHand:current.sprite.position to:ship.sprite.position delay:1.0f];
        }
        return NO;
    } removeOnYES:NO exit:NO];
    [self showMessage:NSLocalizedString(@"SurvivalShipTutorial", @"")];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShipTutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)shipAdded:(NSNotification *)note {
	ship = [[note object] retain];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)toDelete {
    return (ship && (ship.toDelete || ship.passengersIn || ship.lifeTime > 7.0f)) || [[NSUserDefaults standardUserDefaults] boolForKey:@"ShipTutorial"];
}

- (void)end {
    [super end];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [ship release];
    [super dealloc];
}

@end
