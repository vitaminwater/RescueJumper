//
//  GameStateActionLevel3.m
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionLevel3.h"

#import "Game.h"
#import "Actioner.h"
#import "PlayerData.h"

#import "GameStateActionLevelEnd.h"

#import "BuildingPlateforme.h"

#import "TouchManager.h"

@implementation GameStateActionLevel3

- (id)initWithGame:(Game *)_game goalBuilding:(BuildingPlateforme *)_goalBuilding  goalBuilding2:(BuildingPlateforme *)_goalBuilding2 {
    
    if (self = [super initWithGame:_game]) {
        goalBuilding = [_goalBuilding retain];
        goalBuilding2 = [_goalBuilding2 retain];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
    }
    return self;
    
}

- (int)getPriority {
	return 0;
}

- (NSObject<Action> *)trigger {
    game.scrollSpeed = 50;
    game.muteMusicFader = NO;
    return [super trigger];
}

- (BOOL)update:(float)dt {
	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] update:dt];
    
	[game processBipedes:dt];
	[game processJumpBases:dt];
    
    if ([goalBuilding.onBoard count] + [goalBuilding2.onBoard count] == 20) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel3Done"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSInteger grade = 3 - (NSInteger)((time - 10) / 2);
        grade = grade < 0 ? 0 : (grade > 3 ? 3 : grade);
        
        NSArray *messages = @[NSLocalizedString(@"GameLevel3Grade1", @""),
        NSLocalizedString(@"GameLevel3Grade2", @""),
        NSLocalizedString(@"GameLevel3Grade3", @""),
        NSLocalizedString(@"GameLevel3Grade4", @"")];
        
        [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelCleared", @"") message:[messages objectAtIndex:grade] grade:grade] autorelease]];
        NSLog(@"%f", time);
        
    } else if ([game.playerData[0].bipedes count] != 20) {
        [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelFailed", @"") message:NSLocalizedString(@"GameLevelFailedKill", @"") grade:0] autorelease]];
    }
    time += dt;
	return YES;
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

- (void)jumpBaseRemoved:(NSNotification *)note {
    if ([[note object] isKindOfClass:[BuildingPlateforme class]])
        game.scrollSpeed = 0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [goalBuilding release];
    [super dealloc];
}

@end
