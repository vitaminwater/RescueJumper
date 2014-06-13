//
//  JumpToNext.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Physics.h"

#import "SimpleAudioEngine.h"

#import "JumpToNext.h"
#import "Fall.h"

#import "Bipede.h"
#import "JumpBase.h"

#import "Game.h"

#import "Ship.h"

#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"
#import "PlayerData.h"

@implementation JumpToNext

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game {
	
	if (self = [super initWithBipede:bipedeArg game:_game]) {
		nextJumpBase = nil;
		memset(lastJumpBases, 0, sizeof(JumpBase *) * JUMP_BASE_MEMORY);
		[self saveJumpBase:bipedeArg.currentJumpBase];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgetJumpBase:) name:JUMP_BASE_REMOVED object:nil];
	}
	return self;
	
}

-(BOOL)canTrigger {
	if (bipede.currentJumpBase && bipede.currentJumpBase.canJump) {
		nextJumpBaseTmp = [bipede.currentJumpBase getNextForPlayer:bipede.player from:&from to:&to waitTime:[bipede getWaitingTime]];
		if (nextJumpBaseTmp != nil && ![self alreadySavedJumpBase:nextJumpBaseTmp]) {
			if (bipede.player < game.nPlayer && [nextJumpBaseTmp type] == JUMPBASE_SHIP && game.playerData[bipede.player].activeBipedes.count <= 1) {
				return NO;
			}
			return YES;
		}
	}
	return NO;
}

- (NSObject<Action> *)trigger {
	nextJumpBase = [nextJumpBaseTmp retain];
	CGRect collidRect = [bipede.currentJumpBase collidRect];
	from.x += collidRect.origin.x;
	from.y += collidRect.origin.y;
	dir = from.x - bipede.sprite.position.x > 0;
	[bipede.movement run:dir];
	if (bipede.player < game.nPlayer && [nextJumpBase type] == JUMPBASE_SHIP)
		[game.playerData[bipede.player] setBipedeActive:bipede active:NO];
	nextJumpBase.timeUnused = 0;
	return [super trigger];
}

-(int)getPriority
{
	return 5;
}

-(BOOL)update:(float)dt
{
	if (bipede.currentJumpBase) {
		if (nextJumpBase != nil && nextJumpBase.active &&
			dir != (from.x - bipede.sprite.position.x > 0)) {
			[self jumpToNext];
			//[[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
			bipede.currentJumpBase = nil;
		} else if (nextJumpBase == nil || !nextJumpBase.active) {
			[bipede.movement stand:dir];
			return NO;
		}
	} else {
		if (nextJumpBase && bipede.Vy < 0 && nextJumpBase.active && CGRectIntersectsRect(CGRectMake(bipede.sprite.position.x - bipede.sprite.size.width / 2, bipede.sprite.position.y + bipede.Vy * dt, bipede.sprite.size.width, bipede.sprite.size.height), [nextJumpBase collidRect])) {
			bipede.currentJumpBase = nextJumpBase;
			[self saveJumpBase:nextJumpBase];
			[bipede.movement land:dir];
			if (bipede.player < game.nPlayer) {
				[game.playerData[bipede.player] addStat:STAT_N_JUMPS n:1 pts:JUMPS_SCORE];
                [game addScore:JUMPS_SCORE player:bipede.player];
            }
			bipede.Vx = 0;
			bipede.Vy = 0;
			return NO;
		} else if (!nextJumpBase || !nextJumpBase.active) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"tombe.wav"];
			next = [[Fall alloc] initWithBipede:bipede game:game];
			if (bipede.player < game.nPlayer) {
				[game.playerData[bipede.player] addStat:STAT_N_MISSED_JUMPS n:1 pts:FAILED_JUMP_SCORE];
                [game addScore:FAILED_JUMP_SCORE player:bipede.player pos:ccpAdd(bipede.sprite.position, ccp(0, bipede.sprite.size.height / 2.0f))];
            }
			return NO;
		}
	}
	return YES;
}

- (void)jumpToNext {
	CGPoint result;
	double te;
	CGRect collidRect = [nextJumpBase collidRect];
	if (![Physics jumpFrom:bipede.sprite.position
				   to:CGPointMake(collidRect.origin.x + to.x, collidRect.origin.y + to.y)
			   result:&result te:&te])
		return;
	[bipede.movement jumpUp:result.x > 0];
	bipede.Vx = result.x;
	bipede.Vy = result.y;
}

- (void)end:(BOOL)interrupted {
    if (interrupted && !bipede.currentJumpBase) {
        memset(lastJumpBases, 0, sizeof(JumpBase *) * JUMP_BASE_MEMORY);
        if (bipede.player < game.nPlayer) {
            [game.playerData[bipede.player] addStat:STAT_N_MISSED_JUMPS n:1 pts:FAILED_JUMP_SCORE];
            [game addScore:FAILED_JUMP_SCORE player:bipede.player pos:ccpAdd(bipede.sprite.position, ccp(0, bipede.sprite.size.height / 2.0f))];
        }
    }
	[nextJumpBase release];
	nextJumpBase = nil;
}

- (NSObject<Action> *)next {
	NSObject<Action> *tmp = next;
	next = nil;
	return [tmp autorelease];
}

- (void)saveJumpBase:(JumpBase *)jumpBase {
	for(int i = 0; i < JUMP_BASE_MEMORY - 1; ++i) {
		lastJumpBases[i] = lastJumpBases[i + 1];
	}
	lastJumpBases[JUMP_BASE_MEMORY - 1] = jumpBase;
}

- (BOOL)alreadySavedJumpBase:(JumpBase *)jumpBase {
	for (int i = 0; i < JUMP_BASE_MEMORY; ++i) {
		if (lastJumpBases[i] == jumpBase)
			return YES;
	}
	return NO;
}

- (void)forgetJumpBase:(NSNotification *)note {
    if (nextJumpBase == [note object]) {
		[nextJumpBase release];
        nextJumpBase = nil;
	}
	for (int i = 0; i < JUMP_BASE_MEMORY; ++i) {
		if (lastJumpBases[i] == [note object]) {
			lastJumpBases[i] = 0;
			return;
		}
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[nextJumpBase release];
	nextJumpBase = nil;
	[super dealloc];
}

@end
