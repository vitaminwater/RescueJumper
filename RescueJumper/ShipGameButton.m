//
//  ShipGameButton.m
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ShipGameButton.h"

#import "Display.h"

#import "Game.h"
#import "SurvivalGameData.h"

#import "Actioner.h"
#import "GameStateSurvivalAction.h"

#import "LevelGenerator.h"
#import "ShipGenerator.h"

@implementation ShipGameButton

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player {
    
    if (self = [super initWithGame:_game gameData:_gameData player:_player sprite:@"bt_navette.png"]) {
        
        sprite.position = ccp(10 + sprite.contentSize.width / 2, 10 + sprite.contentSize.height / 2);
        
        buttonType = SHIP_BUTTON;
        
    }
    return self;
    
}

- (BOOL)execute {
    __block BOOL done = NO;
    [((GameStateSurvivalAction *)game.gameStateActioner.currentAction).levelGenerator.elements iterateOrRemove:^BOOL(id entry) {
        if ([entry class] == [ShipGenerator class]) {
            ShipGenerator *element = entry;
            [element execute];
            done = YES;
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    return done;
}

@end
