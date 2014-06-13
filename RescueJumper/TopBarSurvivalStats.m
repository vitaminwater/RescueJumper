//
//  TopBarSurvivalStats.m
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TopBarSurvivalStats.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "StatItem.h"
#import "StatItemMax.h"

#import "ShipProgress.h"

@implementation TopBarSurvivalStats

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player {
    
    if (self = [super init]) {
        game = _game;
        gameData = _gameData;
        player = _player;
        
        numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
		[numberFormatter setGroupingSeparator:@" "];
        
        CCSprite *tmpStatSprite = [CCSprite spriteWithFile:@"topbar_level.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(5, 19);
		[self addChild:tmpStatSprite];
		
		levelLabel = [CCLabelBMFont labelWithString:@"1" fntFile:@"burgley19.fnt"];
		levelLabel.anchorPoint = ccp(0, 0.5);
		levelLabel.position = ccp(35, 16);
        levelLabel.scale = 1.4f;
		[self addChild:levelLabel];
		
		tmpStatSprite = [CCSprite spriteWithFile:@"topbar_star.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(65, 19);
		[self addChild:tmpStatSprite];
		
		scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"burgley19.fnt"];
		scoreLabel.anchorPoint = ccp(0, 0.5);
		scoreLabel.position = ccp(95, 16);
        scoreLabel.scale = 1.4f;
		[self addChild:scoreLabel];
		
		tmpStatSprite = [CCSprite spriteWithFile:@"topbar_sablier.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(230, 19);
		[self addChild:tmpStatSprite];
		
		timeLeftLabel = [CCLabelBMFont labelWithString:@"0:00" fntFile:@"burgley19.fnt"];
		timeLeftLabel.anchorPoint = ccp(0, 0.5);
		timeLeftLabel.position = ccp(260, 16);
        timeLeftLabel.scale = 1.4f;
		[self addChild:timeLeftLabel];
		
		tmpStatSprite = [CCSprite spriteWithFile:player ? @"topbar_temps2.png" : @"topbar_temps.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(330, 19);
		[self addChild:tmpStatSprite];
		
		timeForNext = [CCLabelBMFont labelWithString:@"0:00" fntFile:@"burgley19.fnt"];
		timeForNext.anchorPoint = ccp(0, 0.5);
		timeForNext.position = ccp(360, 16);
        timeForNext.scale = 1.4f;
		[self addChild:timeForNext];
		
		tmpStatSprite = [CCSprite spriteWithFile:@"topbar_coin.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(430, 19);
		[self addChild:tmpStatSprite];
		
		coinLabel = [CCLabelBMFont labelWithString:@"$ 0" fntFile:@"burgley19.fnt"];
		coinLabel.anchorPoint = ccp(0, 0.5);
		coinLabel.position = ccp(460, 16);
        coinLabel.scale = 1.4f;
		[self addChild:coinLabel];
		
		tmpStatSprite = [CCSprite spriteWithFile:@"topbar_human.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(560, 19);
		[self addChild:tmpStatSprite];
		
		bobLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"burgley19.fnt"];
		bobLabel.anchorPoint = ccp(0, 0.5);
		bobLabel.position = ccp(590, 16);
        bobLabel.scale = 1.4f;
		[self addChild:bobLabel];
        
		tmpStatSprite = [CCSprite spriteWithFile:@"topbar_zombie.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0.5);
		tmpStatSprite.position = ccp(630, 19);
		[self addChild:tmpStatSprite];
		
		zombieLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"burgley19.fnt"];
		zombieLabel.anchorPoint = ccp(0, 0.5);
		zombieLabel.position = ccp(660, 16);
        zombieLabel.scale = 1.4f;
		[self addChild:zombieLabel];
		
        shipProgress = [[ShipProgress alloc] init];
        shipProgress.position = ccp(730, 19);
        [self addChild:shipProgress];
        [shipProgress release];
        
		tmpStatSprite = [CCSprite spriteWithFile:@"topbar_separator.png"];
		tmpStatSprite.anchorPoint = ccp(0, 0);
		tmpStatSprite.position = ccp(970, 0);
		[self addChild:tmpStatSprite];
    }
    return self;
    
}

- (void)update:(ccTime)dt {
    scoreLabel.string = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:(int)game.playerData[player].score]];
	timeLeftLabel.string = [NSString stringWithFormat:@"%d:%02d", (int)gameData.timeLeft / 60, (int)gameData.timeLeft % 60];
	timeForNext.string = [NSString stringWithFormat:@"%d:%02d", (int)gameData.timeForNext / 60, (int)gameData.timeForNext % 60];
	coinLabel.string = [NSString stringWithFormat:@"$ %d", (int)[[game.playerData[player] getStatItem:STAT_COINS] resultN]];
	levelLabel.string = [NSString stringWithFormat:@"%d", (int)gameData.currentLevel];
	bobLabel.string = [NSString stringWithFormat:@"%d", (int)[game.playerData[player].bipedes count]];
	zombieLabel.string = [NSString stringWithFormat:@"%d", (int)[((StatItemMax *)[game.playerData[player] getStatItem:STAT_MAX_ZOMBIES]) currentN]];
    shipProgress.progress = gameData.shipProgress;
    
    if (gameData.timeLeft < 10.0f && (int)gameData.timeLeft) {
		CGFloat cosTime = cosf(time * 10.0f);
		CGFloat newScale = cosTime * 0.5f + 1.4f;
		timeLeftLabel.scale = newScale < 1.2f ? 1.2f + (newScale - 1.2f) / 6 : newScale;
		timeLeftLabel.color = (ccColor3B){(GLubyte)200 * (newScale > 1.2f ? (newScale - 1.2f) / 0.7f : 0) + (GLubyte)55, (GLubyte)0, (GLubyte)0};
	} else if (!(int)gameData.timeLeft) {
		timeLeftLabel.scale += (1.4f - timeLeftLabel.scale) / 20;
		timeLeftLabel.color = ccRED;
	} else {
		timeLeftLabel.scale = 1.4f;
		timeLeftLabel.color = ccWHITE;
	}
	CGFloat cosTime = cosf(time * 5.0f);
	if (gameData.timeForNext < 10.0f)
		timeForNext.color = (cosTime > 0 ? ccWHITE : ccRED);
	else
		timeForNext.color = ccWHITE;
    [shipProgress update:dt];
    time += dt;
}

- (void)dealloc {
	[numberFormatter release];
	[super dealloc];
}

@end
