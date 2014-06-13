//
//  TourelleGameButton.m
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TourelleGameButton.h"

#import "Display.h"

#import "Game.h"

#import "Tourelle.h"

@implementation TourelleGameButton

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player {
    
    if (self = [super initWithGame:_game gameData:_gameData player:_player sprite:@"bt_missile.png"]) {
        
        sprite.position = ccp(10 + sprite.contentSize.width / 2, 20 + sprite.contentSize.height * 1.5);
        
        buttonType = TOURELLE_BUTTON;
        
    }
    return self;
    
}

- (BOOL)execute {
    Tourelle *tourelle = [[Tourelle alloc] initWithGame:game player:player];
    [game.interactiveElements addEntry:tourelle];
    [tourelle release];
    return YES;
}

@end
