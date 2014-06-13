//
//  Hospital.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Hospital.h"

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "StaticDisplayObject.h"

#import "Display.h"
#import "Game.h"

#import "MBDACenter.h"

#import "Bipede.h"

#import "MBDACenter.h"
#import "MissilLauncher.h"

@implementation Hospital

- (id)initWithGame:(Game *)_game {
	
	if (self = [super initWithGame:_game]) {		
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:[NSString stringWithFormat:@"hopital-back%d.png", (rand() % 2) + 1] anchor:ccp(0.5, 0.0) isSpriteFrame:NO];

		scanDelay = 2;
		sprite = _sprite;
		size = sprite.size;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BLOCK_BACK z:0];

		front = [[StaticDisplayObject alloc] initSprite:[NSString stringWithFormat:@"hopital-front%d.png", (rand() % 2) + 1] anchor:ccp(0.5, 0.0) isSpriteFrame:NO];

		[self setPosition:ccp(-[Display sharedDisplay].scrollX +
							  [Display sharedDisplay].size.width +
							  _sprite.size.width / 2, 0)];

		[[Display sharedDisplay] addDisplayObject:front onNode:BLOCK_FRONT z:0];

		launcher = [[MissilLauncher alloc] initWithPosition:ccp(0, 0) direction:ccp(0, 800)];
		[[MBDACenter sharedMBDACenter].launchers addEntry:[launcher autorelease]];

		active = YES;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpBaseRemoved:) name:JUMP_BASE_REMOVED object:nil];
	}
	return self;

}

- (void)update:(ccTime)dt {
	launcher.position = ccpAdd(sprite.position, ccp(sprite.size.width / 2 - 50, sprite.size.height - 100));
	scanDelay -= dt;
	if (scanDelay < 0) {
		[[MBDACenter sharedMBDACenter].aims iterateOrRemove:^BOOL(id entry) {
			NSObject<MissilAim> *current = entry;
			if (current.player == ZOMBIE_PLAYER)
				[launcher addAim:current];
			return NO;
		} removeOnYES:NO exit:NO];
		scanDelay = 5;
	}
	[super update:dt];
}

- (void)bipedeAdded:(Bipede *)bipede {
	[super bipedeAdded:bipede];
}

- (void)setPosition:(CGPoint)pos {
	sprite.position = pos;
	front.position = pos;
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - 424 / 2, 0, 424, 165);
}

- (CGFloat)touchHeightAdded {
    return 110;
}

- (NSUInteger)type {
    return JUMPBASE_HOSPITAL;
}

- (void)dealloc {
	[[MBDACenter sharedMBDACenter].launchers iterateOrRemove:^BOOL(id entry) {
		return entry == launcher;
	} removeOnYES:YES exit:YES];
	[front release];
	[super dealloc];
}

@end
