//
//  GameLevel4.m
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameLevel4.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "Actioner.h"

#import "Game.h"
#import "PlayerData.h"

#import "JumpPlateforme.h"
#import "BuildingPlateforme.h"

#import "Hospital.h"

#import "CollidObject.h"

#import "BlackHole.h"

#import "Bipede.h"

#import "GameStateActionLevel4.h"
#import "GameStateActionLevelEnd.h"
#import "GameStateActionTutorial.h"

#import "BaseTutorial.h"

@implementation GameLevel4

- (BOOL)canPlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel3Done"];
}

- (NSString *)getLevelIcon {
    NSUInteger isDone = [self canPlay] ? 1 : 0;
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [NSString stringWithFormat:@"level4_%d_ipad.png", isDone];
#endif
    return [NSString stringWithFormat:@"level4_%d_iphone.png", isDone];
}

- (void)initGame:(Game *)game {
    JumpPlateforme *first = [[JumpPlateforme alloc] initWithPlayer:0 level:1 game:game];
    first.sprite.position = ccp(512, [Display sharedDisplay].size.height / 2);
    [first activate];
    first.isDeletable = NO;
    [game.jumpBases addEntry:first];
    [first release];
    
    Bipede *firstBipede = [[Bipede alloc] initWithJumpBase:first player:0 game:game];
    [game.playerData[0].bipedes addEntry:firstBipede];
    [firstBipede release];
    
    BuildingPlateforme *building = [[BuildingPlateforme alloc] initWithSprite:@"building2.png" game:game isSpriteFrame:NO];
    building.sprite.position = ccp(1024 - building.size.width / 2, building.size.height);
    [building activate];
    [game.jumpBases addEntry:building];
    [building release];
    
    for (int i = 0; i < 10; ++i) {
        Bipede *bipede = [[Bipede alloc] initWithJumpBase:building player:NEUTRAL_PLAYER game:game];
        [game.pnjs addEntry:bipede];
        [bipede release];
    }
    
    for (int i = 0; i < 4; ++i) {
        CollidObject *collidObject = [[CollidObject alloc] initWithGame:game size:(rand() % 4) + 1 mvt:i % 2 breakable:YES from:CGPointMake(0, 200) to:CGPointMake(0, -200)];
        collidObject.position = ccp(1300 + i * 40,
                                    [Display sharedDisplay].size.height - collidObject.sprite.size.height / 2 - (rand() % (int)([Display sharedDisplay].size.height - collidObject.sprite.size.height)));
        [game.collidObjects addEntry:collidObject];
        [collidObject release];
    }
    
    for (int i = 0; i < 1; ++i) {
        BlackHole *blackHole = [[BlackHole alloc] initWithGame:game size:1.0];
        blackHole.sprite.position = ccp(1350 + 300 * i, 50.0f + rand() % (int)([Display sharedDisplay].size.height - blackHole.sprite.size.height - 86));
        [game.interactiveElements addEntry:blackHole];
        [blackHole release];
    }
    
    Hospital *hospital = [[Hospital alloc] initWithGame:game];
    [hospital setPosition:ccp(2048, 0)];
    [hospital activate];
    hospital.canHaveNext = NO;
    [game.jumpBases addEntry:hospital];
    [hospital release];
    
    [game.gameStateActioner addAction:[[[GameStateActionLevel4 alloc] initWithGame:game hospital:hospital] autorelease]];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel4TutoShown"]) {
        GameStateActionTutorial *tutorialAction = [[GameStateActionTutorial alloc] initWithGame:game];
        BaseTutorial *tutorial = [[BaseTutorial alloc] initWithGame:game];
        [tutorial showMessage:NSLocalizedString(@"GameLevel4Intro", @"")];
        [tutorialAction.tutorials addEntry:tutorial];
        [tutorial release];
        
        [game.gameStateActioner addAction:tutorialAction];
        [tutorialAction release];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel4TutoShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [[Display sharedDisplay] displayMessage:NSLocalizedString(@"GameLevel4ShortIntro", @"")];
}

@end
