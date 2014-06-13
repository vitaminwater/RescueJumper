//
//  GameLevel2.m
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameLevel2.h"

#import "Game.h"
#import "PlayerData.h"
#import "Actioner.h"
#import "Display.h"
#import "StaticDisplayObject.h"

#import "GameStateActionLevel2.h"
#import "GameStateActionLevelEnd.h"
#import "GameStateActionTutorial.h"

#import "BaseTutorial.h"
#import "Level2ShipTutorial.h"

#import "JumpPlateforme.h"
#import "BuildingPlateforme.h"
#import "Ship.h"

#import "Bipede.h"

@implementation GameLevel2

- (BOOL)canPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel1Done"];
}

- (NSString *)getLevelIcon {
    NSUInteger isDone = [self canPlay] ? 1 : 0;
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [NSString stringWithFormat:@"level2_%d_ipad.png", isDone];
#endif
    return [NSString stringWithFormat:@"level2_%d_iphone.png", isDone];
}

- (void)initGame:(Game *)game {
    
    JumpPlateforme *first = [[JumpPlateforme alloc] initWithPlayer:0 level:1 game:game];
    first.sprite.position = ccp(100, [Display sharedDisplay].size.height / 2);
    [first activate];
    first.isDeletable = NO;
    [game.jumpBases addEntry:first];
    [first release];
    
    Bipede *firstBipede = [[Bipede alloc] initWithJumpBase:first player:0 game:game];
    [game.playerData[0].bipedes addEntry:firstBipede];
    [firstBipede release];
    
    Ship *ship = [[Ship alloc] initWithGame:game position:ccp([Display sharedDisplay].size.width + 200, [Display sharedDisplay].size.height / 2) capacity:4];
    [game.jumpBases addEntry:ship];
    [ship release];

    BuildingPlateforme *building = [[BuildingPlateforme alloc] initWithSprite:@"building0.png" game:game isSpriteFrame:NO];
    building.sprite.position = ccp(building.sprite.size.width / 2, building.size.height);
    [building activate];
    building.canHaveNext = NO;
    [game.jumpBases addEntry:building];
    [building release];

    for (int i = 0; i < 4; ++i) {
        Bipede *bipede = [[Bipede alloc] initWithJumpBase:building player:NEUTRAL_PLAYER game:game];
        [game.pnjs addEntry:bipede];
        [bipede release];
    }
    
    [game.gameStateActioner addAction:[[[GameStateActionLevel2 alloc] initWithGame:game ship:ship] autorelease]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel2TutoShown"]) {
        GameStateActionTutorial *tutorialAction = [[GameStateActionTutorial alloc] initWithGame:game];
        BaseTutorial *tutorial = [[BaseTutorial alloc] initWithGame:game];
        [tutorial showMessage:NSLocalizedString(@"GameLevel2Intro", @"")];
        [tutorial addTutorialHand:ccp(first.sprite.position.x, first.sprite.position.y) to:ccp(building.sprite.position.x, building.sprite.position.y) delay:1];
        [tutorialAction.tutorials addEntry:tutorial];
        [tutorialAction.tutorials addEntry:[[[Level2ShipTutorial alloc] initWithGame:game ship:ship building:building] autorelease]];
        [tutorial release];
        
        [game.gameStateActioner addAction:tutorialAction];
        [tutorialAction release];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel2TutoShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        ship.Vx = -50;
        ship.desiredVx = -50;
        building.canHaveNext = YES;
        [[Display sharedDisplay] displayMessage:NSLocalizedString(@"GameLevel2ShortIntro", @"")];
    }
}

@end
