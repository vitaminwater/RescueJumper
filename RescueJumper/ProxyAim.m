//
//  ProxyAim.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/4/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ProxyAim.h"

@implementation ProxyAim

@synthesize player;

- (id)initWithDelegate:(NSObject<MissilAim> *)_delegate {
	
	if (self = [super init]) {
		delegate = _delegate;
	}
	return self;
	
}

- (CGPoint)aimPosition {
	return [delegate aimPosition];
}

- (BOOL)hitAndRemove:(Missile *)missile {
	return [delegate hitAndRemove:missile];
}

- (NSInteger)player {
	return delegate.player;
}

@end
