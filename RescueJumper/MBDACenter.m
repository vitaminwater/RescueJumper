//
//  MBDACenter.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "MBDACenter.h"

#import "SimpleAudioEngine.h"

#import "ChainList.h"

#import "StaticDisplayObject.h"

#import "Missile.h"
#import "MissilLauncher.h"

@implementation MBDACenter

KS_SINGLETON_IMPLEMENTATION(MBDACenter)

@synthesize aims;
@synthesize launchers;

- (id)init {

	if (self = [super init]) {
		missils = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:) removeCallBack:@selector(dummyHandler:) delegate:self];
		aims = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:) removeCallBack:@selector(aimRemoved:) delegate:self];
		launchers = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:) removeCallBack:@selector(dummyHandler:) delegate:self];
	}
	return self;

}

- (void)update:(ccTime)dt {
	[missils iterateOrRemove:^BOOL(id entry) {
		Missile *missile = entry;
		[missile update:dt];
		return !missile.sprite.visible || missile.sprite.position.y <= 0;
	} removeOnYES:YES exit:YES];
	[launchers iterateOrRemove:^BOOL(id entry) {
		MissilLauncher *launcher = entry;
		[launcher update:dt];
		return NO;
	} removeOnYES:NO exit:NO];
}

- (void)addMissile:(NSObject<MissilAim> *)aim source:(CGPoint)source direction:(CGPoint)direction player:(NSUInteger)player {
    Missile *missile = [[Missile alloc] initWithSprite:@"missile.png" aim:aim source:source direction:direction];
	missile.player = player;
	[missils addEntry:missile];
    [missile release];
	[[SimpleAudioEngine sharedEngine] playEffect:@"rocket.wav"];
}

- (void)dummyHandler:(id)entry {}

- (void)aimRemoved:(id)entry {
	[launchers iterateOrRemove:^BOOL(id entry2) {
		MissilLauncher *launcher = entry2;
		[launcher.aims iterateOrRemove:^BOOL(id entry3) {
			return entry == entry3;
		} removeOnYES:YES exit:YES];
		return NO;
	} removeOnYES:NO exit:NO];
    [missils iterateOrRemove:^BOOL(id entry2) {
		Missile *missile = entry2;
        if (missile.aim == entry) {
            missile.aim = nil;
        }
		return NO;
	} removeOnYES:NO exit:NO];
}

- (void)forceRelease {
	[super release];
}

+ (void)reset {
	[sharedMBDACenter forceRelease];
	sharedMBDACenter = nil;
}

- (void)dealloc {
	[launchers release];
	[aims release];
	[missils release];
	[super dealloc];
}

@end
