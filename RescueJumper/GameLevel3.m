//
//  GameLevel3.m
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameLevel3.h"

#import "Game.h"
#import "PlayerData.h"
#import "Actioner.h"
#import "Display.h"
#import "StaticDisplayObject.h"

#import "GameStateActionLevel3.h"
#import "GameStateActionLevelEnd.h"
#import "GameStateActionTutorial.h"

#import "BaseTutorial.h"

#import "JumpPlateforme.h"
#import "BuildingPlateforme.h"
#import "Ship.h"

#import "Bipede.h"

@implementation GameLevel3

- (BOOL)canPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel2Done"];
}

- (NSString *)getLevelIcon {
    NSUInteger isDone = [self canPlay] ? 1 : 0;
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [NSString stringWithFormat:@"level3_%d_ipad.png", isDone];
#endif
    return [NSString stringWithFormat:@"level3_%d_iphone.png", isDone];
}

- (void)initGame:(Game *)game {
    
    BuildingPlateforme *goalBuilding2 = [[BuildingPlateforme alloc] initWithSprite:@"building2.png" game:game isSpriteFrame:NO];
    goalBuilding2.sprite.position = ccp([Display sharedDisplay].size.width, goalBuilding2.size.height);
    [goalBuilding2 activate];
    goalBuilding2.canHaveNext = NO;
    [game.jumpBases addEntry:goalBuilding2];
    [goalBuilding2 release];
    
    BuildingPlateforme *goalBuilding = [[BuildingPlateforme alloc] initWithSprite:@"plateform.png" game:game isSpriteFrame:YES];
    goalBuilding.sprite.position = ccp([Display sharedDisplay].size.width, [Display sharedDisplay].size.height * 0.6);
    [goalBuilding activate];
    goalBuilding.canHaveNext = NO;
    [game.jumpBases addEntry:goalBuilding];
    [goalBuilding release];

    BuildingPlateforme *building = [[BuildingPlateforme alloc] initWithSprite:@"plateform.png" game:game isSpriteFrame:YES];
    building.sprite.position = ccp([Display sharedDisplay].size.width / 2, goalBuilding2.sprite.position.y + (goalBuilding.sprite.position.y - goalBuilding2.sprite.position.y) / 2);
    [building activate];
    [game.jumpBases addEntry:building];
    [building release];
    
    for (int i = 0; i < 20; ++i) {
        Bipede *bipede = [[Bipede alloc] initWithJumpBase:building player:0 game:game];
        [game.playerData[0].bipedes addEntry:bipede];
        [bipede release];
    }

    [game.gameStateActioner addAction:[[[GameStateActionLevel3 alloc] initWithGame:game goalBuilding:goalBuilding goalBuilding2:goalBuilding2] autorelease]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel3TutoShown"]) {
        GameStateActionTutorial *tutorialAction = [[GameStateActionTutorial alloc] initWithGame:game];
        BaseTutorial *tutorial = [[BaseTutorial alloc] initWithGame:game];
        [tutorial showMessage:NSLocalizedString(@"GameLevel3Intro", @"")];
        [tutorial addTutorialHand:ccp(building.sprite.position.x + building.sprite.size.width / 2, building.sprite.position.y) to:ccp(goalBuilding.sprite.position.x - goalBuilding.sprite.size.width / 2, goalBuilding.sprite.position.y) delay:1];
        [tutorial addTutorialHand:ccp(building.sprite.position.x + building.sprite.size.width / 2, building.sprite.position.y) to:ccp(goalBuilding2.sprite.position.x - goalBuilding2.sprite.size.width / 2, goalBuilding2.sprite.position.y) delay:2];
        [tutorialAction.tutorials addEntry:tutorial];
        [tutorial release];
        
        [game.gameStateActioner addAction:tutorialAction];
        [tutorialAction release];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel3TutoShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [[Display sharedDisplay] displayMessage:NSLocalizedString(@"GameLevel3ShortIntro", @"")];
}

@end
