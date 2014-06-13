//
//  Level2ShipTutorial.m
//  RescueJumper
//
//  Created by Constantin on 12/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Level2ShipTutorial.h"

#import "Display.h"

#import "Game.h"
#import "PlayerData.h"

#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"

#import "JumpBase.h"
#import "BuildingPlateforme.h"
#import "Ship.h"

@implementation Level2ShipTutorial

- (id)initWithGame:(Game *)_game ship:(Ship *)_ship building:(BuildingPlateforme *)_building {
    
    if (self = [super initWithGame:_game]) {
        
        done = NO;
        ship = _ship;
        building = _building;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
        
    }
    return self;
    
}

- (BOOL)canTrigger {
    return [building.onBoard count] == 5;
}

- (void)trigger {
    [super trigger];
    endButtMenu.visible = NO;
    ship.Vx = -100;
    ship.desiredVx = -100;
}

- (BOOL)update:(ccTime)dt {
    if (done)
        return [super update:dt];
    if (!done && ship.sprite.position.x + ship.sprite.size.width / 2 < [Display sharedDisplay].size.width * 3 / 4 && ![game.pnjs count]) {
        done = YES;
        ship.Vx = -50;
        ship.desiredVx = -50;
        [self showMessage:NSLocalizedString(@"GameLevel2ShipTutorial", @"")];
        [self addTutorialHand:ccpAdd(building.sprite.position, ccp(building.sprite.size.width / 2, 0)) to:ship.sprite.position delay:1];
        building.canHaveNext = YES;
    } else
        [game processJumpBases:dt];
    [game processBipedes:dt];
    return YES;
}

- (BOOL)toDelete {
    return !ship || done;
}

- (void)end {
    [super end];
}

- (void)jumpBaseRemoved:(NSNotification *)note {
    if ([note object] == ship) {
        ship = nil;
    }
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
