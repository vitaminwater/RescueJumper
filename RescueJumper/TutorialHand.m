//
//  TutorialHand.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 8/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TutorialHand.h"

#import "Display.h"
#import "Screen.h"
#import "BorderedCCSprite.h"

#import "Game.h"
#import "PlayerData.h"

#import "Physics.h"

#define HAND_UP ccp(10.0f, -10.0f)
#define HAND_DOWN ccp(0.0f, 0.0f)

@implementation TutorialHand

- (id)initWithStart:(CGPoint)start end:(CGPoint)end delay:(ccTime)_delay game:(Game *)_game {
	
	if (self = [super init]) {
		currentStep = 0;
		delay = _delay;
		stepWait = -1;
        game = _game;
		
		CGFloat dist = sqrtf(powf(end.x - start.x, 2) + powf(end.y - start.y, 2));
		nSteps = 2;
		if (dist > _game.playerData[0].maxJumpDistance)
			nSteps = roundf(dist / _game.playerData[0].maxJumpDistance) + 1;
		steps = malloc((nSteps) * sizeof(CGPoint));
		stepSprites = malloc((nSteps - 1) * sizeof(CCSprite *));
		for (int i = 0; i < nSteps; ++i) {
			steps[i] = ccpAdd(start, CGPointMake(((end.x - start.x) / ((CGFloat)nSteps - 1)) * (CGFloat)i, ((end.y - start.y) / ((CGFloat)nSteps - 1)) * (CGFloat)i));
			if (!i)
				continue;
			stepSprites[i - 1] = [BorderedCCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"palette_%d__%d.png", 1, _game.playerData[0].jumpBaseLevel]];
			stepSprites[i - 1].position = steps[i];
			stepSprites[i - 1].visible = NO;
            ((BorderedCCSprite *)stepSprites[i - 1]).borderColor = ccc3(255, 0, 0);
			[[Display sharedDisplay].screens[0].frontNode addChild:stepSprites[i - 1]];
		}
        
		pathSprites = malloc(sizeof(CCSprite *) * PATH_NODES * (nSteps - 1));
        
		for (int i = 0; i < PATH_NODES * (nSteps - 1); ++i) {
			pathSprites[i] = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"jumpb%d_%d.png", 1, ((i % 14) + 1)]];
			pathSprites[i].opacity = 127;
			pathSprites[i].anchorPoint = ccp(0.5, 0);
			pathSprites[i].visible = NO;
            [[Display sharedDisplay].screens[0].pathNode addChild:pathSprites[i]];
		}
		
		shadow = [CCSprite spriteWithFile:@"hand_shadow.png"];
		shadow.anchorPoint = ccp(0.38f, 1.0f);
		shadow.opacity = 0;
		
		hand = [CCSprite spriteWithFile:@"hand.png"];
		hand.anchorPoint = ccp(0.35f, 1.0f);
		hand.opacity = 0;
        hand.position = HAND_UP;
        hand.scale = 1.0f + hand.position.x / 70.0f;
		handPos = HAND_UP;
		
		handNode = [CCNode node];
		handNode.position = start;
		
		[handNode addChild:shadow];
		[handNode addChild:hand];
		
		[[Display sharedDisplay].screens[0].frontNode addChild:handNode];
	}
	return self;
	
}

- (BOOL)update:(ccTime)dt {
    time += dt;
	if (hand.opacity < 255) {
		hand.opacity += 5;
		shadow.opacity = hand.opacity;
	}

	CGPoint V = ccp((handPos.x - hand.position.x) * dt * 6, (handPos.y - hand.position.y) * dt * 6);
	hand.position = ccpAdd(hand.position, V);
	hand.scale = 1.0f + hand.position.x / 70.0f;

    [self updatePathsScale];
    
	if (delay > 0) {
		delay -= dt;
		return YES;
	}
	
	if (V.x > 0.1f || V.y  > 0.1f)
		return YES;
	
	if (stepWait < 0 && currentStep != nSteps) {
		V = ccp((steps[currentStep].x - handNode.position.x) * dt * 5.0f, (steps[currentStep].y - handNode.position.y) * dt * 5.0f);
		handNode.position = ccpAdd(handNode.position, V);
		if (currentStep) {
			stepSprites[currentStep - 1].position = handNode.position;
			if (currentStep < nSteps) {
				stepSprites[currentStep - 1].visible = YES;
				stepSprites[currentStep - 1].opacity = 127.0f;
                [self updatePathsPosition];
			}
		}
		if (fabs(V.x) < 0.1f && fabs(V.y) < 0.1f) {
			stepWait = 0.3f;
			handPos = currentStep == 0 ? HAND_DOWN : HAND_UP;
			if (currentStep)
				stepSprites[currentStep - 1].opacity = 255.0f;
			++currentStep;
		}
	} else if (stepWait >= 0) {
		stepWait -= dt;
		if (stepWait < 0.0f) {
			if (currentStep == nSteps)
				return NO;
			handPos = HAND_DOWN;
		}
	}
	return YES;
}

- (void)updatePathsPosition {
    CGPoint result;
    double te;
    [Physics jumpFrom:steps[currentStep - 1] to:stepSprites[currentStep - 1].position result:&result te:&te];
    double t = (te / PATH_NODES) / 2;
    for (NSInteger i = 0; i < PATH_NODES; ++i) {
        pathSprites[(currentStep - 1) * PATH_NODES + i].visible = YES;
        pathSprites[(currentStep - 1) * PATH_NODES + i].position = CGPointMake(steps[currentStep - 1].x + result.x * t,
                    steps[currentStep - 1].y + result.y * t - (NEWTON_G * t * t) / 2);
        t += te / PATH_NODES;
    }
}

- (void)updatePathsScale {
    for (NSInteger i = 0; i < PATH_NODES * (nSteps - 1) && pathSprites[i].visible; ++i)
        pathSprites[i].scale = 1.0f + cosf((float)i + -time * 10.0f) / 6.0f;
}

- (void)dealloc {
	free(steps);
	
	for (NSInteger i = 0; i < (nSteps - 1); ++i) {
		[stepSprites[i] removeFromParentAndCleanup:YES];
	}
	free(stepSprites);
    
    for (NSInteger i = 0; i < PATH_NODES * (nSteps - 1); ++i) {
        [pathSprites[i] removeFromParentAndCleanup:YES];
    }
    free(pathSprites);
	
	[handNode removeFromParentAndCleanup:YES];
	[super dealloc];
}

@end
