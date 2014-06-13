//
//  BaseTutorial.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseTutorial.h"

#import "Game.h"

#import "Display.h"
#import "Screen.h"
#import "TextDisplayObject.h"
#import "StaticDisplayObject.h"

#import "AnimatedNode.h"

#import "TutorialMessage.h"

#import "TutorialHand.h"

@interface BaseTutorial() {
    
    ccTime lastShine;
    
}

@end

@implementation BaseTutorial

- (id)initWithGame:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		time = 0;
		tutorialHands = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
	}
	return self;
	
}

- (BOOL)canTrigger {
	return YES;
}

- (void)trigger {
	scrollSpeed = game.scrollSpeed;
	endButtPressed = NO;
	game.muteMusicFader = YES;

    endButtSprite = [[AnimatedNode alloc] init];
    [endButtSprite initAnimatedNode:nil defaultSprite:@"s17.png" defaultScale:1];
    [endButtSprite initAnim:@"shine" n:17 delay:1.0f/30 animPrefix:@"s"];
    [endButtSprite setAnim:@"shine" repeat:NO];
    CCMenuItem *endItem = [CCMenuItemSprite itemFromNormalSprite:endButtSprite.sprite selectedSprite:nil target:self selector:@selector(endButtPressed:)];
    endButtMenu = [CCMenu menuWithItems:endItem, nil];
    endButtMenu.position = ccp(0, 0);
    endButtMenu.visible = NO;
    endButtMenu.position = ccp([Display sharedDisplay].size.width / 2, [Display sharedDisplay].size.height / 2);
    [[Display sharedDisplay].screens[0].rootNode addChild:endButtMenu];
}

- (void)endButtPressed:(id)sender {
    if (text && ![text fillMessage]) {
        [text release];
        text = nil;
        if (![tutorialHands count])
            endButtPressed = YES;
    } else if (!text)
        endButtPressed = YES;
    endButtMenu.visible = NO;
}

- (BOOL)update:(ccTime)dt {
	game.scrollSpeed += -game.scrollSpeed * dt * 2;
    if (endButtMenu.visible && time - lastShine > 3) {
		[endButtSprite setAnim:@"shine" repeat:NO];
        lastShine = time;
	}
	if ((text && [text update:dt]) || (!text && ![tutorialHands count]))
		[self showEndButton];
    if (!text) {
        [tutorialHands iterateOrRemove:^BOOL(id entry) {
            TutorialHand *current = entry;
            return ![current update:dt];
        } removeOnYES:YES exit:NO];
    }
	time += dt;
	return !endButtPressed;
}

- (BOOL)toDelete {
	return NO;
}

- (void)end {
    [text release];
    text = nil;
	[endButtMenu removeFromParentAndCleanup:YES];
    endButtMenu = nil;
	game.muteMusicFader = NO;
	game.scrollSpeed = scrollSpeed;
	[tutorialHands iterateOrRemove:^BOOL(id entry) {
		return YES;
	} removeOnYES:YES exit:NO];
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{
	return YES;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player{
}

- (void)showEndButton {
	endButtMenu.visible = YES;
}

- (void)addTutorialHand:(CGPoint)from to:(CGPoint)to delay:(ccTime)delay {
	TutorialHand *hand = [[TutorialHand alloc] initWithStart:from end:to delay:delay game:game];
	[tutorialHands addEntry:hand];
	[hand release];
}

- (void)showMessage:(NSString *)message {
    [text release];
    text = [[TutorialMessage alloc] initWithString:message screen:0];
    [text fillMessage];
}

- (void)dummy:(id)entry {}

- (void)dealloc {
    [text release];
	[tutorialHands release];
    [endButtSprite release];
	[super dealloc];
}

@end
