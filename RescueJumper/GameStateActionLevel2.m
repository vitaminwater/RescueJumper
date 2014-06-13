//
//  GameStateActionLevel2.m
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionLevel2.h"

#import "Game.h"
#import "Actioner.h"
#import "PlayerData.h"

#import "GameStateActionLevelEnd.h"

#import "TouchManager.h"

#import "Ship.h"

@implementation GameStateActionLevel2

- (id)initWithGame:(Game *)_game ship:(Ship *)_ship {
    
    if (self = [super initWithGame:_game]) {
        ship = _ship;
        ship.shipDelegate = self;
        full = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
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
    
    if (full) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel2Done"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSInteger grade = 3 - (NSInteger)((time - 7) / 2);
        grade = grade < 0 ? 0 : (grade > 3 ? 3 : grade);
        
        NSArray *messages = @[NSLocalizedString(@"GameLevel2Grade1", @""),
        NSLocalizedString(@"GameLevel2Grade2", @""),
        NSLocalizedString(@"GameLevel2Grade3", @""),
        NSLocalizedString(@"GameLevel2Grade4", @"")];
        
        [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelCleared", @"") message:[messages objectAtIndex:grade] grade:grade] autorelease]];
        NSLog(@"%f", time);

    } else if (!ship || [game.playerData[0].bipedes count] + [game.pnjs count] + ship.passengersIn < 5) {
        if ([game.playerData[0].bipedes count] + [game.pnjs count] + ship.passengersIn < 5)
            [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelFailed", @"") message:NSLocalizedString(@"GameLevelFailedKill", @"") grade:0] autorelease]];
        else
            [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelFailed", @"") message:NSLocalizedString(@"GameLevel2Failed", @"") grade:0] autorelease]];
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

- (void)shipFull:(Ship *)ship player:(NSUInteger)player {
    full = YES;
}

- (void)shipDestroyed:(Ship *)ship {
    
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
