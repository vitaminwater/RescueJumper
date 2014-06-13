//
//  GameStateActionLevel4.m
//  RescueJumper
//
//  Created by Constantin on 11/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionLevel4.h"

#import "Display.h"
#import "StaticDisplayObject.h"

#import "Game.h"
#import "Actioner.h"
#import "PlayerData.h"

#import "GameStateActionLevelEnd.h"

#import "TouchManager.h"

#import "Hospital.h"

@implementation GameStateActionLevel4

- (id)initWithGame:(Game *)_game hospital:(Hospital *)_hospital {
    
    if (self = [super initWithGame:_game]) {
        hospital = [_hospital retain];
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
    if (hospital.sprite.position.x < -[Display sharedDisplay].scrollX - hospital.sprite.size.width / 2 + [Display sharedDisplay].size.width) {
        game.scrollSpeed = 0;
    }
    
	for (int i = 0; i < game.nPlayer; ++i)
		[game.touchManager[i] update:dt];
    
	[game processBipedes:dt];
	[game processJumpBases:dt];
    [game processCollidRect:dt];
    
    int nBipedes = [game.pnjs count] + [game.playerData[0].bipedes count];
    
    if ([hospital.onBoard count] == nBipedes && !game.scrollSpeed) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GameLevel4Done"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelCleared", @"") message:NSLocalizedString(@"GameLevel4Cleared", @"") grade:3] autorelease]];
        
    } else if (nBipedes < 7)
        [game.gameStateActioner addAction:[[[GameStateActionLevelEnd alloc] initWithGame:game title:NSLocalizedString(@"GameLevelFailed", @"") message:NSLocalizedString(@"GameLevelFailedKill", @"") grade:0] autorelease]];
    
	return YES;
}

- (void)end:(BOOL)interrupted {
    game.scrollSpeed = 0;
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
    [hospital release];
    [super dealloc];
}

@end
