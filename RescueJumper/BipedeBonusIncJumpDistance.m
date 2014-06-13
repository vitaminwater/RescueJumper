//
//  BipedeBonusLvlUp.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeBonusIncJumpDistance.h"
#import "cocos2d.h"
#import "Bipede.h"
#import "Game.h"
#import "PlayerData.h"
#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"

@implementation BipedeBonusIncJumpDistance

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super initWithBipede:_bipede game:_game]) {
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"bonus_saut.png" anchor:ccp(0.5, 0) isSpriteFrame:YES];
		sprite = _sprite;
		sprite.position = ccp(bipede.sprite.size.width / 2, bipede.sprite.size.height);
		[bipede.sprite addSubDisplayObject:sprite];
	}
	return self;
	
}

- (void)execute {
	if (game.playerData[bipede.player].maxJumpDistance < 280)
		game.playerData[bipede.player].maxJumpDistance += 25;
}

- (void)bipedeSizeChanged {
	sprite.position = ccp(bipede.sprite.size.width / 2, bipede.sprite.size.height);
}

- (NSString *)bonusSprite {
    return @"icon_saut.png";
}

@end
