//
//  Screen.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"
#import "ccTypes.h"

#import "Display.h"
#import "Screen.h"

#import "ColoredQuad.h"

#import "SimpleAudioEngine.h"

#import "ShipProgress.h"

#import "Game.h"
#import "PlayerData.h"
#import "StatItem.h"
#import "StatItemMax.h"

@implementation Screen

@synthesize player;

@synthesize rootNode;
@synthesize scrollNode;
@synthesize backNode;
@synthesize bonusNode;
@synthesize blockBackNode;
@synthesize bipedeNode;
@synthesize otherBipedeNode;
@synthesize blockFrontNode;
@synthesize pathNode;
@synthesize frontNode;
@synthesize shipNode;

@synthesize topStatBarBG;

- (id)initWithScreenSize:(CGSize)_size player:(NSUInteger)_player game:(Game *)_game {
	
	if (self = [super init]) {
		player = _player;
		game = _game;
		
		realScreenSize = _size;
		
		self.anchorPoint = ccp(0, 0);
		
		rootNode = [CCNode node];
		scrollNode = [CCNode node];
		
		rootNode.anchorPoint = ccp(0, 0);
		rootNode.scale = realScreenSize.width / [Display getDeviceReferenceWidth];
		size = CGSizeMake([Display getDeviceReferenceWidth], realScreenSize.height / rootNode.scale);
		
		topStatBarBG = [CCSprite spriteWithFile:@"topbar_bg.png" rect:CGRectMake(0, 0, [Display getDeviceReferenceWidth], 36)];
		topStatBarBG.position = ccp(0, size.height);
		topStatBarBG.anchorPoint = ccp(0, 1);
		[topStatBarBG.texture setTexParameters:&(ccTexParams){ GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT }];
		[rootNode addChild:topStatBarBG];
        
        topStatBarBorder = [CCSprite spriteWithFile:@"topbar_hachure.png" rect:CGRectMake(0, 0, [Display getDeviceReferenceWidth], 5)];
		topStatBarBorder.position = ccp(0, size.height - topStatBarBG.contentSize.height);
		topStatBarBorder.anchorPoint = ccp(0, 1);
        [topStatBarBorder.texture setTexParameters:&(ccTexParams){ GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT }];
		[rootNode addChild:topStatBarBorder];
		
		playButt = [CCSprite spriteWithFile:@"topbar_play.png"];
		playButt.anchorPoint = ccp(0, 0.5);
		playButt.position = ccp([Display sharedDisplay].size.width - 30, 19);
		[topStatBarBG addChild:playButt];
		
		playButt.visible = NO;
		
		pauseButt = [CCSprite spriteWithFile:@"topbar_pause.png"];
		pauseButt.anchorPoint = ccp(0, 0.5);
		pauseButt.position = playButt.position;
		[topStatBarBG addChild:pauseButt];
		
		pauseButt.visible = YES;
		pauseButt.opacity = 127;

		backNode = [CCNode node];
		bonusNode = [CCSpriteBatchNode batchNodeWithFile:@"bonus.png"];
		blockBackNode = [CCNode node];
		bipedeNode = [CCSpriteBatchNode batchNodeWithFile:@"atlas_human.png"];
		otherBipedeNode = [CCNode node];
		blockFrontNode = [CCNode node];
		pathNode = [CCNode node];
		shipNode = [CCSpriteBatchNode batchNodeWithFile:@"atlas_ship.png"];
		frontNode = [CCNode node];

		[scrollNode addChild:backNode];
		[scrollNode addChild:bonusNode];
		[scrollNode addChild:blockBackNode];
		[scrollNode addChild:bipedeNode];
		[scrollNode addChild:otherBipedeNode];
		[scrollNode addChild:blockFrontNode];
		[scrollNode addChild:pathNode];
		[scrollNode addChild:shipNode];
		[scrollNode addChild:frontNode];
		[rootNode addChild:scrollNode];
		
		[self addChild:rootNode];
        
        messageNode = [[ColoredQuad alloc] initWithRect:CGRectMake(0, 0, size.width, 50) color:ccc4(0, 0, 0, 127)];
        messageNode.visible = NO;
        message = [CCLabelBMFont labelWithString:@"" fntFile:@"burgley40.fnt"];
        message.anchorPoint = ccp(0.5, 0.5);
        message.position = ccp(size.width / 2, 25);
        [messageNode addChild:message];
        [rootNode addChild:messageNode];

		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-100 swallowsTouches:YES];
        
        [self schedule:@selector(update:) interval:1.0f/40.0f];
	}
	return self;

}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint pos = [rootNode convertTouchToNodeSpace:touch];
	CGPoint posInTopStatBar = ccpSub(pos, ccp(topStatBarBG.position.x, topStatBarBG.position.y - topStatBarBG.contentSize.height));
	
	if (CGRectContainsPoint(CGRectMake(playButt.position.x, playButt.position.y - playButt.contentSize.height / 2.0f, playButt.contentSize.width, playButt.contentSize.height), posInTopStatBar)) {
		playButt.opacity = 127;
		pauseButt.opacity = 127;
		buttTouch = touch;
		return YES;
	} else {
		playButt.opacity = 255;
		pauseButt.opacity = 255;
	}
	
	if (CGRectContainsPoint(CGRectMake(0, 0, size.width, size.height), pos)) {
		return [game touchBegan:touch withEvent:event player:player];
	}
	return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	if (touch == buttTouch) {
		CGPoint pos = [[Display sharedDisplay].screens[player].topStatBarBG convertTouchToNodeSpace:touch];
		if (CGRectContainsPoint(CGRectMake(playButt.position.x, playButt.position.y - playButt.contentSize.height / 2.0f, playButt.contentSize.width, playButt.contentSize.height), pos)) {
			playButt.opacity = 127;
			pauseButt.opacity = 127;
		} else {
			playButt.opacity = 255;
			pauseButt.opacity = 255;
		}
		return;
	}
	[game touchMoved:touch withEvent:event player:player];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	if (touch == buttTouch) {
		CGPoint pos = [[Display sharedDisplay].screens[player].topStatBarBG convertTouchToNodeSpace:touch];
		if (CGRectContainsPoint(CGRectMake(playButt.position.x, playButt.position.y - playButt.contentSize.height / 2.0f, playButt.contentSize.width, playButt.contentSize.height), pos)) {
			playButt.visible = !playButt.visible;
			pauseButt.visible = !pauseButt.visible;
			if (pauseButt.visible) {
				[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
				[[CCDirector sharedDirector] resume];
			} else {
				[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
				[[CCDirector sharedDirector] pause];
			}
			game.scrollSpeed = pauseButt.visible ? 50 : 0;
			playButt.opacity = 255;
			pauseButt.opacity = 255;
		}
		touch = nil;
		return;
	}
	[game touchEnded:touch withEvent:event player:player];
}

- (void)update:(ccTime)dt {
    topStatBarBorder.textureRect = CGRectMake(topStatBarBorder.textureRect.origin.x + game.scrollSpeed * dt,
                              topStatBarBorder.textureRect.origin.y,
                              topStatBarBorder.textureRect.size.width,
                              topStatBarBorder.textureRect.size.height);
    
    if (shaker) {
        rootNode.position = ccp(cosf(time * 100) * shaker, 0);
        shaker /= 1.0f + (dt / (1.0f / 60.0f)) * 0.5;
        shaker = shaker < 1 ? 0 : shaker;
    } else
        rootNode.position = ccp(0, 0);
    
	if (messageDisplayTime) {
        messageNode.position = ccpAdd(messageNode.position, ccp(0, (size.height / 2 - messageNode.position.y - 25) * dt * 2));
		messageDisplayTime -= dt;
		messageDisplayTime = messageDisplayTime < 0 ? 0 : messageDisplayTime;
	} else if (messageNode.visible) {
		messageNode.visible = NO;
	}
	
    [topStat update:dt];
    
	time += dt;
}

- (void)shakeScreen:(CGFloat)force {
    if (shaker < force)
        shaker = force;
}

- (void)displayMessage:(NSString *)_message {
    message.string = _message;
	messageNode.position = ccp(0, size.height);
    messageNode.visible = YES;
	messageDisplayTime = 4;
}

- (void)setTopStat:(CCNode<TopStat> *)_topStat {
    [topStat removeFromParentAndCleanup:YES];
    [topStatBarBG addChild:_topStat];
    topStat = _topStat;
}

- (void)dealloc {
    [self unscheduleAllSelectors];
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super dealloc];
}

@end
