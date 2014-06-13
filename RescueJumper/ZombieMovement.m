//
//  ZombieMovement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ZombieMovement.h"
#import "AnimatedDisplayObject.h"

#import "ChainList.h"

#import "HangAround.h"
#import "JumpToNext.h"

#import "MBDACenter.h"
#import "ProxyAim.h"
#import "Missile.h"
#import "MissileDeath.h"

#import "Game.h"
#import "PlayerData.h"

@implementation ZombieMovement

@synthesize right;
@synthesize player;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		bipede = _bipede;
		
		fromPlayer = bipede.player;
		
        player = ZOMBIE_PLAYER;
        aimObject = [[ProxyAim alloc] initWithDelegate:self];
        [[MBDACenter sharedMBDACenter].aims addEntry:aimObject];
        [aimObject release];
		for (int i = 0; i < game.nPlayer; ++i)
			[game.playerData[i] addStat:STAT_MAX_ZOMBIES n:1 pts:MAX_ZOMBIE_SCORE];
	}
	return self;
	
}

- (void)initAnims {
	[bipede.sprite initAnim:[NSString stringWithFormat:@"run%d", bipede.player + 1] n:19 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"run%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 1] n:30 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"walk%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] n:14 delay:1.0f / 10.0f animPrefix:[NSString stringWithFormat:@"stand%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"die%d", bipede.player + 1] n:1 delay:1.0f animPrefix:[NSString stringWithFormat:@"die%d_", bipede.player + 1]];
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] repeat:YES];
}

- (void)initActions {
	[bipede.actioner removeAllActions];
	[bipede.actioner addAction:[[[HangAround alloc] initWithBipede:bipede game:game] autorelease]];
	[bipede.actioner addAction:[[[JumpToNext alloc] initWithBipede:bipede game:game] autorelease]];
}

- (void)update {
	
}

- (void)run:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"run%d", bipede.player + 1] repeat:YES];
	bipede.Vx = _right ? 120 : -120;
	bipede.sprite.scaleX = _right ? 1 : -1;
	right = _right;
	[bipede sizeChanged];
}

- (void)walk:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 1] repeat:YES];
	bipede.Vx = _right ? 60 : -60;
	bipede.sprite.scaleX = _right ? 1 : -1;
	right = _right;
	[bipede sizeChanged];
}

- (void)stand:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] repeat:YES];
	bipede.Vx = 0;
	bipede.sprite.scaleX = _right ? 1 : -1;
	right = _right;
	[bipede sizeChanged];
}

- (void)jumpUp:(BOOL)_right {
    CGFloat Vx = bipede.Vx;
	[self run:_right];
    bipede.Vx = Vx;
}

- (void)jump:(BOOL)_right {
    CGFloat Vx = bipede.Vx;
	[self run:_right];
    bipede.Vx = Vx;
}

- (void)land:(BOOL)_right {
	[self stand:_right];
}

- (void)speak:(BOOL)_right {
	[self stand:_right];
}

- (void)fear:(BOOL)_right {
	[self stand:_right];
}

- (void)happy:(BOOL)_right {
	[self stand:_right];
}

- (void)onSaved {
	
}

- (void)onKilled {
	
}

- (NSUInteger)getWeight {
	return 1;
}

- (NSString *)savedSprite {
    return @"icon_zombie.png";
}

- (CGPoint)aimPosition {
	return ccpAdd(bipede.sprite.position, ccp(0, 0));
}

- (BOOL)hitAndRemove:(Missile *)missile {
	bipede.Vx = missile.Vx;
	bipede.Vy = 400.0f;
	bipede.currentJumpBase = nil;
    MissileDeath *missileDeath = [[MissileDeath alloc] initWithBipede:bipede game:game];
    [bipede.actioner setCurrentAction:missileDeath interrupted:YES];
    [missileDeath release];
	if (missile.player < game.nPlayer) {
		[game addScore:ZOMBY_KILLED_SCORE player:missile.player pos:ccpAdd(bipede.sprite.position, ccp(0, bipede.sprite.size.height / 2.0f))];
		[game.playerData[missile.player] addStat:STAT_NUKED_ZOMBIES n:1 pts:ZOMBY_KILLED_SCORE];
	}
    aimObject = nil;
	return YES;
}

- (void)dealloc {
    if (aimObject != nil) {
		[[MBDACenter sharedMBDACenter].aims iterateOrRemove:^BOOL(id entry) {
			return entry == aimObject;
		} removeOnYES:YES exit:YES];
	}
	for (int i = 0; i < game.nPlayer; ++i)
		[game.playerData[i] removeStat:STAT_MAX_ZOMBIES n:1 pts:MAX_ZOMBIE_SCORE];
    [super dealloc];
}

@end
