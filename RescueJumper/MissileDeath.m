//
//  MissileDeath.m
//  RescueJumper
//
//  Created by Constantin on 9/16/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "MissileDeath.h"

#import "Bipede.h"

#import "AnimatedDisplayObject.h"

@implementation MissileDeath

- (id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game {

    if (self = [super initWithBipede:bipedeArg game:_game]) {
		
    }
    return self;
    
}

- (NSObject<Action> *)trigger {
    rotSpeed = 150 + rand() % 30;
    bipede.dead = YES;
    bipede.sprite.position = ccp(bipede.sprite.position.x, bipede.sprite.position.y + bipede.sprite.size.height / 2);
    bipede.sprite.anchor = ccp(0.5, 0.5);
    [bipede.sprite setAnim:[NSString stringWithFormat:@"die%d", bipede.player + 1] repeat:NO];
    return self;
}

- (BOOL)update:(float)dt {
    bipede.sprite.rotation += rotSpeed * dt * 3.0f;
	return YES;
}

- (int)getPriority {
	return 100;
}

- (void)end:(BOOL)interrupted {
}

- (void)dealloc {
	[super dealloc];
}

@end
