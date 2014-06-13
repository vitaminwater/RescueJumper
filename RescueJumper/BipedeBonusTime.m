//
//  BipedeBonusTime.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeBonusTime.h"

#import "cocos2d.h"

#import "Display.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"

#import "BipedeAddTimePicker.h"

#import "Bipede.h"

@implementation BipedeBonusTime

@synthesize time;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game gameData:(SurvivalGameData *)_gameData time:(ccTime)_time {
	
	if (self = [super initWithBipede:_bipede game:_game]) {
        gameData = _gameData;
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"bonus_temps.png" anchor:ccp(0.5, 0) isSpriteFrame:YES];
		sprite = _sprite;
		sprite.position = ccp(bipede.sprite.size.width / 2, bipede.sprite.size.height);
		[bipede.sprite addSubDisplayObject:sprite];
		time = _time < 2 ? 2 : _time;
	}
	return self;
	
}

- (void)execute {
	gameData.timeForNext += time;
	game.playerData[bipede.player].currentClockGuysSaved++;
}

- (void)bipedeSizeChanged {
	sprite.position = ccp(bipede.sprite.size.width / 2, bipede.sprite.size.height);
}

- (void)bipedePlayerChanged:(NSUInteger)from to:(NSUInteger)to {
    if (from != ZOMBIE_PLAYER)
        ((BipedeAddTimePicker *)bipede.picker)->currentlyOnField[from] -= time;
    if (to != ZOMBIE_PLAYER)
        ((BipedeAddTimePicker *)bipede.picker)->currentlyOnField[to] += time;
}

- (NSString *)bonusSprite {
    return @"icon_temps.png";
}

- (void)dealloc {
    if (bipede.player != ZOMBIE_PLAYER)
        ((BipedeAddTimePicker *)bipede.picker)->currentlyOnField[bipede.player] -= time;
	[super dealloc];
}

@end
