//
//  GameStateActionLevel1.m
//  RescueJumper
//
//  Created by Constantin on 10/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionLevel1.h"

#import "Game.h"
#import "Actioner.h"
#import "PlayerData.h"

#import "GameStateActionLevelEnd.h"

#import "BuildingPlateforme.h"

#import "TouchManager.h"

@implementation GameStateActionLevel1

- (id)initWithGame:(Game *)_game goalBuilding:(BuildingPlateforme *)_goalBuilding {
    
    if (self = [super initWithGame:_game]) {
        goalBuilding = [_goalBuilding retain];
    }
    return self;
    
}

- (int)getPriority {
	return 0;
}

- (NSObject<Action> *)trigger {
    game.muteMusicFader = NO;
    return [super trigger];
}

- (BOOL)update:(float)dt {
	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] update:dt];
    
	[game processCollidRect:dt];
	[game processBipedes:dt];
	[game processJumpBases:dt];
    
    if ([goalBuilding.onBoard count] >= 10) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel1Done"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSInteger grade = 3 - (NSInteger)((time - 9) / 2);
        grade = grade < 0 ? 0 : (grade > 3 ? 3 : grade);
        
        NSArray *messages = @[NSLocalizedString(@"GameLevel1Grade1", @""),
            NSLocalizedString(@"GameLevel1Grade2", @""),
            NSLocalizedString(@"GameLevel1Grade3", @""),
            NSLocalizedString(@"GameLevel1Grade4", @"")];
        
        [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelCleared", @"") message:[messages objectAtIndex:grade] grade:grade] autorelease]];
        NSLog(@"%f", time);
    } else if ([game.playerData[0].bipedes count] < 10) {
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

- (void)dealloc {
    [goalBuilding release];
    [super dealloc];
}

@end
