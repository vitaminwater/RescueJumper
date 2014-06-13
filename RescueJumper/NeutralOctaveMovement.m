//
//  NeutralOctaveMovement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 5/23/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "NeutralOctaveMovement.h"

#import "AnimatedDisplayObject.h"

#import "HangAround.h"
#import "JumpToNext.h"

#import "Game.h"
#import "PlayerData.h"

@implementation NeutralOctaveMovement

@synthesize right;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		bipede = _bipede;
	}
	return self;
	
}

- (void)initAnims {
	[bipede.sprite initAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 5] n:30 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"walk%d_", bipede.player + 5]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 5] n:14 delay:1.0f / 10.0f animPrefix:[NSString stringWithFormat:@"stand%d_", bipede.player + 5]];
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 5] repeat:YES];
}

- (void)initActions {
	[bipede.actioner removeAllActions];
	[bipede.actioner addAction:[[[HangAround alloc] initWithBipede:bipede game:game] autorelease]];
	[bipede.actioner addAction:[[[JumpToNext alloc] initWithBipede:bipede game:game] autorelease]];
}

- (void)update {
	
}

- (void)run:(BOOL)_right {
	[self walk:_right];
}

- (void)walk:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 5] repeat:YES];
	bipede.Vx = _right ? 40 : -40;
	bipede.sprite.scaleX = _right ? 1 : -1;
	right = _right;
	[bipede sizeChanged];
}

- (void)stand:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 5] repeat:YES];
	bipede.Vx = 0;
	bipede.sprite.scaleX = _right ? 1 : -1;
	right = _right;
	[bipede sizeChanged];
}

- (void)jumpUp:(BOOL)_right {
	CGFloat Vx = bipede.Vx;
	[self walk:_right];
    bipede.Vx = Vx;
}

- (void)jump:(BOOL)_right {
	CGFloat Vx = bipede.Vx;
	[self walk:_right];
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
    CGPoint scorePos = bipede.sprite.position;
    scorePos.x += bipede.sprite.size.width + 20;
    scorePos.y += bipede.sprite.size.height;
	for (int i = 0; i < game.nPlayer; ++i) {
		[game addScore:MISSED_SCORE * 10 player:i pos:scorePos];
        [game.playerData[i] addStat:STAT_MISSED_OCTAVE n:1 pts:MISSED_SCORE * 10];
	}
}

- (NSUInteger)getWeight {
	return 4;
}

- (NSString *)savedSprite {
    return nil;
}

@end
