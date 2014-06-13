//
//  Display.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"
#import "Display.h"
#import "Screen.h"
#import "DisplayObject.h"
#import "Game.h"

#import <AudioToolbox/AudioServices.h>

@implementation Display

KS_SINGLETON_IMPLEMENTATION(Display)

@synthesize screens;
@synthesize n;
@synthesize scrollX;
@synthesize screenSize;
@synthesize size;

- (id)init {
	if (self = [super init]) {
		screens = malloc(sizeof(Screen *) * 2);
		memset(screens, 0, sizeof(Screen *) * 2);
		scrollX = 0;
		self.anchorPoint = ccp(0, 0);
	}
	return self;
}

- (void)initScreens:(NSInteger)_n game:(Game *)game {
	n = _n;
	CGSize winSize = [UIScreen mainScreen].bounds.size;
	CGFloat angle[2];
	CGPoint pos[2];
	if (n == 1) {
		screenSize = CGSizeMake(winSize.height, winSize.width);
		angle[0] = 0;
		angle[1] = 0;
		pos[0] = ccp(0, 0);
		pos[1] = ccp(0, 0);
	} else if (n == 2) {
		screenSize = CGSizeMake(winSize.width, winSize.height / 2);
		angle[0] = 90;
		angle[1] = -90;
		pos[0] = ccp(0, winSize.width);
		pos[1] = ccp(winSize.height, 0);
	}
	size = CGSizeMake([Display getDeviceReferenceWidth], screenSize.height / (screenSize.width / [Display getDeviceReferenceWidth])); //1211
	for (int i = 0; i < n; ++i) {
		screens[i] = [[Screen alloc] initWithScreenSize:screenSize player:i game:game];
		screens[i].rotation = angle[i];
		screens[i].position = pos[i];
		[self addChild:screens[i]];
		[screens[i] release];
	}
}

- (void)addDisplayObject:(DisplayObject *)displayObject onNode:(NODE_TYPE)node z:(NSInteger)z {
	switch (node) {
		case NOSCALE:
			for (int i = 0; i < n; ++i) {
				[screens[i] addChild:displayObject.node[i] z:z];
			}
			break;
		case ROOTNODE:
			for (int i = 0; i < n; ++i) {
				[screens[i].rootNode addChild:displayObject.node[i] z:z];
			}
			break;
		case SCROLL:
			for (int i = 0; i < n; ++i) {
				[screens[i].scrollNode addChild:displayObject.node[i] z:z];
			}
			break;
		case BONUS:
			for (int i = 0; i < n; ++i) {
				[screens[i].bonusNode addChild:displayObject.node[i] z:z];
			}
			break;
		case BACK:
			for (int i = 0; i < n; ++i) {
				[screens[i].backNode addChild:displayObject.node[i] z:z];
			}
			break;
		case BLOCK_BACK:
			for (int i = 0; i < n; ++i) {
				[screens[i].blockBackNode addChild:displayObject.node[i] z:z];
			}
			break;
		case BIPEDE:
			for (int i = 0; i < n; ++i) {
				[screens[i].bipedeNode addChild:displayObject.node[i] z:z];
			}
			break;
		case OTHER_BIPEDE:
			for (int i = 0; i < n; ++i) {
				[screens[i].otherBipedeNode addChild:displayObject.node[i] z:z];
			}
			break;
		case BLOCK_FRONT:
			for (int i = 0; i < n; ++i) {
				[screens[i].blockFrontNode addChild:displayObject.node[i] z:z];
			}
			break;
		case SHIP:
			for (int i = 0; i < n; ++i) {
				[screens[i].shipNode addChild:displayObject.node[i] z:z];
			}
			break;
		case FRONT:
			for (int i = 0; i < n; ++i) {
				[screens[i].frontNode addChild:displayObject.node[i] z:z];
			}
			break;
		case TOPBAR:
			for (int i = 0; i < n; ++i) {
				[screens[i].topStatBarBG addChild:displayObject.node[i] z:z];
			}
			break;
		default:
			break;
	}
}

- (void)setScrollX:(CGFloat)_scrollX {
	for (int i = 0; i < n; ++i)
		screens[i].scrollNode.position = ccp(_scrollX, screens[i].scrollNode.position.y);
	scrollX = _scrollX;
}

- (void)spawnParticleDict:(NSDictionary *)particleDict pos:(CGPoint)pos {
	for (int i = 0; i < n; ++i) {
		CCParticleSystemQuad *particleRing = [[CCParticleSystemQuad alloc] initWithDictionary:particleDict];
		particleRing.position = pos;
		particleRing.autoRemoveOnFinish = YES;
		[screens[i].frontNode addChild:particleRing z:-1];
        [particleRing release];
	}
}

- (void)shakeScreens:(CGFloat)force {
    for (int i = 0; i < n; ++i) {
        [screens[i] shakeScreen:force];
    }
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)displayMessage:(NSString *)_message {
	for (int i = 0; i < n; ++i) {
		[screens[i] displayMessage:_message];
	}
}

- (void)forceRelease {
	[super release];
}

+ (CGFloat)getDeviceReferenceWidth {
#ifdef UI_USER_INTERFACE_IDIOM
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return 1024;
#endif
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    if (winSize.height > 480) {
        return 1211;
    }
    return 1024;
}

+ (void)reset {
	[sharedDisplay forceRelease];
	sharedDisplay = nil;
}

- (void)dealloc {
	free(screens);
	[super dealloc];
}

@end
