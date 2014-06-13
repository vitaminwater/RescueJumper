//
//  Human.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/5/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HumanMovement.h"
#import "AnimatedDisplayObject.h"
#import "Actioner.h"

#import "HangAround.h"
#import "JumpToNext.h"
#import "SaveNeutralPlayer.h"
#import "EnterMotherShip.h"
#import "GoToZeBuvette.h"

#import "Game.h"
#import "PlayerData.h"
#import "Scores.h"

#import "BipedeBonus.h"

@implementation HumanMovement

@synthesize right;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		bipede = _bipede;
        [game.playerData[bipede.player] addStat:STAT_MAX_HUMANS n:1 pts:MAX_BIPEDE_SCORE];
	}
	return self;
	
}

- (void)initAnims {
	[bipede.sprite initAnim:[NSString stringWithFormat:@"run%d", bipede.player + 1] n:19 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"run%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 1] n:30 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"walk%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] n:14 delay:1.0f / 10.0f animPrefix:[NSString stringWithFormat:@"stand%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"jumpUp%d", bipede.player + 1] n:15 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"jumpa%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"jump%d", bipede.player + 1] n:14 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"jumpb%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"land%d", bipede.player + 1] n:26 delay:1.0f / 60.0f animPrefix:[NSString stringWithFormat:@"jumpc%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"speak%d", bipede.player + 1] n:14 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"speak%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"fear%d", bipede.player + 1] n:15 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"fear%d_", bipede.player + 1]];
	[bipede.sprite initAnim:[NSString stringWithFormat:@"happy%d", bipede.player + 1] n:15 delay:1.0f / 30.0f animPrefix:[NSString stringWithFormat:@"happy%d_", bipede.player + 1]];
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] repeat:YES];
}

- (void)initActions {
	[bipede.actioner removeAllActions];
	[bipede.actioner addAction:[[[HangAround alloc] initWithBipede:bipede game:game] autorelease]];
	[bipede.actioner addAction:[[[JumpToNext alloc] initWithBipede:bipede game:game] autorelease]];
	[bipede.actioner addAction:[[[SaveNeutralPlayer alloc] initWithBipede:bipede game:game] autorelease]];
	[bipede.actioner addAction:[[[EnterMotherShip alloc] initWithBipede:bipede game:game] autorelease]];
	[bipede.actioner addAction:[[[GoToZeBuvette alloc] initWithBipede:bipede game:game] autorelease]];
}

- (void)update {
	if (jumping && [bipede.sprite animEnded]) {
		[self jump:right];
	}
}

- (void)run:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"run%d", bipede.player + 1] repeat:YES];
	bipede.Vx = _right ? 120 : -120;
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)walk:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"walk%d", bipede.player + 1] repeat:YES];
	bipede.Vx = _right ? 60 : -60;
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)stand:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"stand%d", bipede.player + 1] repeat:YES];
	bipede.Vx = 0;
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)jumpUp:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"jumpUp%d", bipede.player + 1] repeat:NO];
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = YES;
	right = _right;
	[bipede sizeChanged];
}

- (void)jump:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"jump%d", bipede.player + 1] repeat:YES];
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)land:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"land%d", bipede.player + 1] repeat:NO];
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
}

- (void)speak:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"speak%d", bipede.player + 1] repeat:YES];
	bipede.Vx = 0;
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)fear:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"fear%d", bipede.player + 1] repeat:YES];
	bipede.Vx = 0;
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)happy:(BOOL)_right {
	[bipede.sprite setAnim:[NSString stringWithFormat:@"happy%d", bipede.player + 1] repeat:YES];
	bipede.Vx = 0;
	bipede.sprite.scaleX = _right ? 1 : -1;
	jumping = NO;
	right = _right;
	[bipede sizeChanged];
}

- (void)onSaved {
	CGPoint scorePos = bipede.sprite.position;
	scorePos.y += bipede.sprite.size.height;
	[game addScore:SAVED_SCORE player:bipede.player pos:scorePos];
    [game.playerData[bipede.player] addStat:STAT_SAVED_HUMAN n:1 pts:SAVED_SCORE];
}

- (void)onKilled {
	CGPoint scorePos = bipede.sprite.position;
	scorePos.y += bipede.sprite.size.height;
	[game addScore:KILLED_SCORE player:bipede.player pos:scorePos];
    [game.playerData[bipede.player] addStat:STAT_KILLED_HUMAN n:1 pts:KILLED_SCORE];
}

- (NSUInteger)getWeight {
	return 1;
}

- (NSString *)savedSprite {
    return (bipede.bonus ? [bipede.bonus bonusSprite] : nil);
}

- (void)dealloc {
    [game.playerData[bipede.player] removeStat:STAT_MAX_HUMANS n:1 pts:MAX_BIPEDE_SCORE];
    [super dealloc];
}

@end
