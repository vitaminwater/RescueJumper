//
//  BipedeBonusLvlUp.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeBonusLvlUp.h"

#import "cocos2d.h"

#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"

#import "Game.h"
#import "PlayerData.h"
#import "BipedeJumpBaseLvlUpPicker.h"

#import "Bipede.h"

@implementation BipedeBonusLvlUp

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super initWithBipede:_bipede game:_game]) {
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"bonus_poids.png" anchor:ccp(0.5, 0) isSpriteFrame:YES];
		sprite = _sprite;
		sprite.position = ccp(bipede.sprite.size.width / 2, bipede.sprite.size.height);
		[bipede.sprite addSubDisplayObject:sprite];
	}
	return self;
	
}

- (void)execute {
	if (game.playerData[bipede.player].jumpBaseLevel < 3)
		game.playerData[bipede.player].jumpBaseLevel++;
}

- (void)bipedeSizeChanged {
	sprite.position = ccp(bipede.sprite.size.width / 2, bipede.sprite.size.height);
}

- (NSString *)bonusSprite {
    return @"icon_poids.png";
}

- (void)dealloc {
    ((BipedeJumpBaseLvlUpPicker *)bipede.picker).currentlyOnField--;
    [super dealloc];
}

@end
