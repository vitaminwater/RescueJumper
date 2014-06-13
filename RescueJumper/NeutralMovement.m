//
//  Neutral.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "NeutralMovement.h"
#import "AnimatedDisplayObject.h"

#import "HangAround.h"

#import "Game.h"
#import "Scores.h"
#import "PlayerData.h"

@implementation NeutralMovement

@synthesize right;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		bipede = _bipede;
	}
	return self;
	
}

- (void)initAnims {
	[bipede.sprite initAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 1] n:30 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"walk%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] n:14 delay:1.0f / 10.0f animPrefix:[NSString stringWithFormat:@"stand%d_", bipede.player + 1]];
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] repeat:YES];
}

- (void)initActions {
	[bipede.actioner removeAllActions];
	[bipede.actioner addAction:[[[HangAround alloc] initWithBipede:bipede game:game] autorelease]];
}

- (void)update {
	
}

- (void)run:(BOOL)_right {
	[self walk:_right];
	right = _right;
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
    CGPoint scorePos = bipede.sprite.position;
    scorePos.x += bipede.sprite.size.width + 20;
    scorePos.y += bipede.sprite.size.height;
	for (int i = 0; i < game.nPlayer; ++i) {
		[game addScore:MISSED_SCORE player:i pos:scorePos];
        [game.playerData[i] addStat:STAT_MISSED_HUMAN n:1 pts:MISSED_SCORE];
	}
}

- (NSUInteger)getWeight {
	return 1;
}

- (NSString *)savedSprite {
    return nil;
}

@end
