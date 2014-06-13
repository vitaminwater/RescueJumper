//
//  BaseGameButton.m
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseGameButton.h"

#import "Display.h"
#import "Screen.h"

#import "Actioner.h"
#import "GameStateSurvivalAction.h"

#import "Game.h"
#import "SurvivalGameData.h"

@implementation BaseGameButton

@synthesize sprite;
@synthesize buttonType;
@synthesize player;
@synthesize nLeft;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player sprite:(NSString *)_sprite {
    
    if (self = [super init]) {
        game = _game;
        gameData = _gameData;
        player = _player;
        
        time = 0;
        
        sprite = [CCSprite spriteWithFile:_sprite];
        sprite.opacity = 100;
        sprite.visible = NO;
        
        nLeftLabel = [[CCLabelBMFont alloc] initWithString:@"0" fntFile:@"burgley19.fnt"];
        nLeftLabel.position = ccp(107, 14);
        nLeftLabel.anchorPoint = ccp(0.5f, 0.5f);
        
        [sprite addChild:nLeftLabel];
        [nLeftLabel release];
        
        [[Display sharedDisplay].screens[player].rootNode addChild:sprite];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-101 swallowsTouches:YES];
    }
    return self;
    
}

- (BOOL)update:(ccTime)dt {
    if (gameData.currentLevel > 6 && [game.gameStateActioner.currentAction isKindOfClass:[GameStateSurvivalAction class]])
        sprite.visible = ((GameStateSurvivalAction *)game.gameStateActioner.currentAction).showButtons;
    else
        return YES;
    time += dt;
    return YES;
}

- (BOOL)execute { return YES; }

- (void)addLeft:(NSUInteger)_addLeft {
    nLeft += _addLeft;
    nLeftLabel.string = [NSString stringWithFormat:@"%d", nLeft];
    sprite.opacity = 255;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!sprite.visible)
        return NO;
    CGPoint pos = [[Display sharedDisplay].screens[player].rootNode convertTouchToNodeSpace:touch];
    if (sprite.opacity == 255 && CGRectContainsPoint(CGRectMake(sprite.position.x - sprite.contentSize.width / 2, sprite.position.y - sprite.contentSize.height / 2,
                                       sprite.contentSize.width, sprite.contentSize.height), pos)) {
        sprite.opacity = 127;
        return YES;
    }
	return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pos = [[Display sharedDisplay].screens[player].rootNode convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(CGRectMake(sprite.position.x - sprite.contentSize.width / 2, sprite.position.y - sprite.contentSize.height / 2,
                                       sprite.contentSize.width, sprite.contentSize.height), pos))
        sprite.opacity = 127;
    else
        sprite.opacity = 255;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pos = [[Display sharedDisplay].screens[player].rootNode convertTouchToNodeSpace:touch];
    sprite.opacity = 255;
    if (!sprite.visible)
        return;
    if (CGRectContainsPoint(CGRectMake(sprite.position.x - sprite.contentSize.width / 2, sprite.position.y - sprite.contentSize.height / 2,
                                       sprite.contentSize.width, sprite.contentSize.height), pos)) {
        if ([self execute]) {
            nLeft--;
            nLeftLabel.string = [NSString stringWithFormat:@"%d", nLeft];
            if (!nLeft)
                sprite.opacity = 100;
        }
    }
}

- (void)dealloc {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [sprite removeFromParentAndCleanup:YES];
    [super dealloc];
}

@end
