//
//  GameLevel1.m
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameLevel1.h"

#import "Game.h"
#import "PlayerData.h"
#import "Actioner.h"

#import "GameStateActionLevel1.h"
#import "GameStateActionLevelEnd.h"
#import "GameStateActionTutorial.h"

#import "BaseTutorial.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "JumpPlateforme.h"
#import "BuildingPlateforme.h"

#import "Bipede.h"

@implementation GameLevel1

- (BOOL)canPlay {
    return YES;
}

- (NSString *)getLevelIcon {
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return @"level1_1_ipad.png";
#endif
    return @"level1_1_iphone.png";
}

- (void)initGame:(Game *)game {
    BuildingPlateforme *building = [[BuildingPlateforme alloc] initWithSprite:@"plateform.png" game:game isSpriteFrame:YES];
    building.sprite.position = ccp(building.sprite.size.width / 2 + 50, [Display sharedDisplay].size.height / 2);
    [building activate];
    [game.jumpBases addEntry:building];
    [building release];
    
    for (int i = 0; i < 10; ++i) {
        Bipede *bipede = [[Bipede alloc] initWithJumpBase:building player:0 game:game];
        [game.playerData[0].bipedes addEntry:bipede];
        [bipede release];
    }
    
    BuildingPlateforme *goalBuilding = [[BuildingPlateforme alloc] initWithSprite:@"building1.png" game:game isSpriteFrame:NO];
    goalBuilding.sprite.position = ccp([Display sharedDisplay].size.width - goalBuilding.sprite.size.width / 2, goalBuilding.size.height);
    [goalBuilding activate];
    goalBuilding.canHaveNext = NO;
    [game.jumpBases addEntry:goalBuilding];
    [goalBuilding release];
    
    [game.gameStateActioner addAction:[[[GameStateActionLevel1 alloc] initWithGame:game goalBuilding:goalBuilding] autorelease]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel1TutoShown"]) {
        GameStateActionTutorial *tutorialAction = [[GameStateActionTutorial alloc] initWithGame:game];
        BaseTutorial *tutorial = [[BaseTutorial alloc] initWithGame:game];
        [tutorial showMessage:NSLocalizedString(@"GameLevel1Intro", @"")];
        [tutorial addTutorialHand:ccp(building.sprite.position.x + building.sprite.size.width / 2, building.sprite.position.y) to:ccp(goalBuilding.sprite.position.x - goalBuilding.sprite.size.width / 2 + 20, goalBuilding.sprite.position.y) delay:1];
        [tutorialAction.tutorials addEntry:tutorial];
        [tutorial release];
        
        [game.gameStateActioner addAction:tutorialAction];
        [tutorialAction release];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel1TutoShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [[Display sharedDisplay] displayMessage:NSLocalizedString(@"GameLevel1ShortIntro", @"")];
}

@end
