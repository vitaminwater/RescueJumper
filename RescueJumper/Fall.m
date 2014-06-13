//
//  Fall.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Fall.h"

#import "Game.h"
#import "PlayerData.h"
#import "JumpBase.h"
#import "Bipede.h"
#import "AnimatedDisplayObject.h"

@implementation Fall

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game {
	
	if (self = [super initWithBipede:bipedeArg game:_game]) {
		
	}
	return self;
	
}

- (NSObject<Action> *)trigger {
    timeStart = 0;
    [bipede.movement jump:bipede.movement.right];
    [bipede displayMessage:@"!" scale:2.0f];
    return self;
}

- (BOOL)update:(float)dt {
	__block BOOL result = YES;
	timeStart += dt;
	if (bipede.Vy > 0)
		return YES;
	[game.jumpBases iterateOrRemove:^BOOL(id entry) {
		JumpBase *jumpBase = entry;
		if (!(jumpBase.active && (jumpBase.player == NEUTRAL_PLAYER || jumpBase.player == bipede.player || bipede.player == ZOMBIE_PLAYER)))
			return NO;
		CGRect collidRect = [jumpBase collidRect];
		if (collidRect.origin.y + collidRect.size.height / 2 > bipede.sprite.position.y ||
            (bipede.player == ZOMBIE_PLAYER && jumpBase.type == JUMPBASE_SHIP))
			return NO;
		if (CGRectIntersectsRect(collidRect,
								 CGRectMake(bipede.sprite.position.x - bipede.sprite.size.width / 2 + bipede.Vx * dt,
											bipede.sprite.position.y + bipede.Vy * dt,
											bipede.sprite.size.width, bipede.sprite.size.height))) {
									 result = NO;
									 bipede.currentJumpBase = jumpBase;
									 bipede.Vx = 0;
									 bipede.Vy = 0;
									 [bipede.movement land:rand() % 2];
									 [bipede displayMessage:nil scale:0];
									 if (bipede.player < game.nPlayer && jumpBase.player == bipede.player && timeStart > jumpBase.lifeTime) {
										 [bipede displayMessage:@"Nice catch :D" scale:1.0f];
										 [game.playerData[bipede.player] addStat:STAT_NICE_CATCH n:1 pts:NICE_CATCH_SCORE];
										 [game addScore:NICE_CATCH_SCORE player:bipede.player pos:CGPointMake(bipede.sprite.position.x, bipede.sprite.position.y + bipede.sprite.size.height)];
									 }
									 return YES;
								 }
		return NO;
	} removeOnYES:NO exit:YES];
	return result;
}

- (int)getPriority {
	return 45;
}

- (void)dealloc {
	[super dealloc];
}

@end
