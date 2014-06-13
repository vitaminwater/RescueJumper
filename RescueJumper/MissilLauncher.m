//
//  MissilLauncher.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/3/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "MissilLauncher.h"

#import "Game.h"

#import "MBDACenter.h"

@implementation MissilLauncher

@synthesize aims;
@synthesize nextAim;
@synthesize player;
@synthesize position;
@synthesize direction;

- (id)initWithPosition:(CGPoint)_position direction:(CGPoint)_direction {
	
	if (self = [super init]) {
		position = _position;
        direction = _direction;
		shootDelay = 0.8;
		player = NEUTRAL_PLAYER;
		aims = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:) removeCallBack:@selector(aimRemoved:) delegate:self];
		current = 0;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    if (![aims count])
        return;
	shootDelay -= dt;
	if (shootDelay <= 0) {
		NSUInteger tmp = (current + 1) % aims.count;
        nextAim = nil;
		[aims iterateOrRemove:^BOOL(id entry) {
			NSObject<MissilAim> *aim = entry;
			if (!current) {
				[[MBDACenter sharedMBDACenter] addMissile:aim source:position direction:direction player:player];
			} else if (current < 0) {
                nextAim = aim;
                return YES;
            }
			current--;
			return NO;
		} removeOnYES:NO exit:YES];
        if (!nextAim)
            nextAim = [aims lastInserted];
		current = tmp;
		shootDelay = 0.8;
	}
}

- (void)addAim:(NSObject<MissilAim> *)aim {
	__block BOOL alreadyIn = NO;
	[aims iterateOrRemove:^BOOL(id entry) {
		return (alreadyIn = (entry == aim));
	} removeOnYES:NO exit:YES];
	if (alreadyIn)
		return;
    if (![aims count])
        nextAim = aim;
	[aims addEntry:aim];
}

- (void)aimRemoved:(id)entry {
    if (entry == nextAim)
        nextAim = nil;
}

- (void)dummyHandler:(id)entry {}

- (void)dealloc {
	[aims release];
	[super dealloc];
}

@end
