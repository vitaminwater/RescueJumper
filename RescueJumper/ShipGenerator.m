//
//  EasyShipElement.m
//  RescueJumper
//
//  Created by Constantin on 8/11/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ShipGenerator.h"

#import "ChainList.h"

#import "LevelGenerator.h"
#import "BuildingGenerator.h"
#import "BipedeGenerator.h"
#import "BipedeAddTimePicker.h"
#import "BipedeNeutralPicker.h"

#import "Display.h"
#import "AnimatedDisplayObject.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "Ship.h"

@interface ShipGenerator ()

- (void)findTimePicker;

@end

@implementation ShipGenerator

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
    
    if (self = [super initWithGame:_game gameData:_gameData]) {
        [self findTimePicker];
		penalty = 0;
    }
    return self;
    
}

- (void)update:(ccTime)dt {
	[super update:dt];
	if (penalty) {
		penalty -= dt;
		penalty = penalty < 0 ? 0 : penalty;
	}
    
    if (!gameData.timeLeft) {
        [generatedElements iterateOrRemove:^BOOL(id entry) {
            Ship *ship = entry;
            [ship leave];
            return NO;
        } removeOnYES:NO exit:NO];
    }
}

- (BOOL)canTrigger {
    
    if (!timePicker)
        [self findTimePicker];
	
    if (!gameData.timeLeft || [self hasBlockingShip])
        return NO;
    
    if (timePicker && gameData.currentLevel < 7) {
        ccTime currentlyOnField = timePicker->currentlyOnField[PLAYER1] + timePicker->currentlyOnField[PLAYER2];
        if (currentlyOnField > (20 + gameData.currentLevel * 2) || (currentlyOnField > 0 && gameData.timeLeft < 15))
            return YES;
    }
    
    NSUInteger nBipedes = 0;
    
    for (int i = 0; i < game.nPlayer; ++i)
        nBipedes += [game.playerData[i].bipedes count];
    
    NSUInteger requiredBipedes = [BipedeNeutralPicker calcRequiredBipedes:game gameData:gameData] + gameData.currentLevel;
    
    gameData.shipProgress = (CGFloat)nBipedes / (CGFloat)requiredBipedes;
    
    return nBipedes >= requiredBipedes;
}

- (BOOL)hasBlockingShip {
	if (penalty)
		return YES;
    if ([generatedElements count]) {
        Ship *ship = [generatedElements lastInserted];
        NSUInteger nBipede = 0;
        for (int i = 0; i < game.nPlayer; ++i)
            nBipede += [game.playerData[i].bipedes count];
        if (!ship.active && nBipede > game.nPlayer)
            return NO;
        return YES;
    }
    return NO;
}

- (void)execute {
	
	NSUInteger nRequiredBipedes = [BipedeNeutralPicker calcRequiredBipedes:game gameData:gameData];
	nRequiredBipedes = nRequiredBipedes > 30 ? 30 : nRequiredBipedes;
	
	Ship *ship = [[Ship alloc] initWithGame:game
								   position:ccp([Display sharedDisplay].size.width - [Display sharedDisplay].scrollX,
												[Display sharedDisplay].size.height / 2)
								   capacity:((CGFloat)nRequiredBipedes) * 1.20f + gameData.currentLevel];
	[game.jumpBases addEntry:ship];
    [generatedElements addEntry:ship];
    ship.shipDelegate = self;
	[[NSNotificationCenter defaultCenter] postNotificationName:SHIP_ADDED object:ship];
    [ship release];
    
    gameData.shipProgress = 1;
    
	[super execute];
}

- (void)findTimePicker {
    [levelGenerator.elements iterateOrRemove:^BOOL(id entry) {
        if (![entry isKindOfClass:[BuildingGenerator class]])
            return NO;
        BuildingGenerator *buildingElement = entry;
        [buildingElement.bipedeGenerator.bipedePickers iterateOrRemove:^BOOL(id entry) {
            if (![entry isKindOfClass:[BipedeAddTimePicker class]])
                return NO;
            timePicker = entry;
            return YES;
        } removeOnYES:NO exit:YES];
        return YES;
    } removeOnYES:NO exit:YES];
}

- (void)shipDestroyed:(Ship *)ship {
	if (ship == [generatedElements lastInserted]) {
		penalty = 4.0f;
	}
}

- (void)shipFull:(Ship *)ship player:(NSUInteger)player {
    //[TestFlight passCheckpoint:@"SHIP_FULL"];
    [game.playerData[player] addStat:STAT_SHIP_FULL n:1 pts:SHIP_FULL_SCORE * gameData.currentLevel];
    [game addScore:SHIP_FULL_SCORE * gameData.currentLevel player:player pos:ccp(ship.sprite.position.x, ship.sprite.position.y + ship.sprite.size.height / 2)];
}

@end
