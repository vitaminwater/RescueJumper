//
//  BipedeBonus.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BipedeBonus.h"
#import "BipedePicker.h"

@implementation BipedeBonus

@synthesize sprite;
@synthesize bipede;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game {
	
	if (self = [super init]) {
		bipede = _bipede;
		game = _game;
	}
	return self;
	
}

- (void)execute {}

- (void)bipedeSizeChanged {}

- (void)bipedePlayerChanged:(NSUInteger)from to:(NSUInteger)to {}

- (NSString *)bonusSprite {return @"";}

- (void)dealloc {
    [sprite release];
	[super dealloc];
}

@end
