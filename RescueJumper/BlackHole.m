//
//  BlackHole.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/14/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BlackHole.h"
#import "StaticDisplayObject.h"
#import "Display.h"
#import "Bipede.h"
#import "AnimatedDisplayObject.h"
#import "Game.h"

#import "Actioner.h"

#import "SwallowByBlackHole.h"
#import "AvoidDanger.h"

#import "ParticleDisplayObject.h"

@implementation BlackHole

- (id)initWithGame:(Game *)_game size:(CGFloat)_size {
	
	if (self = [super initWithGame:_game]) {
		
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"blackhole.png" anchor:ccp(0.5, 0.5) isSpriteFrame:YES];
		_sprite.scale = _size;
		sprite = _sprite;
		size = sprite.size;
		size.width *= _size; size.height *= _size;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BONUS z:0];
		//Vx = (game.scrollSpeed / 2.5);
		
		//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
			_sprite.opacity = 0.5;
			particles = [[ParticleDisplayObject alloc] initParticleNode:@"blackhole.plist" scale:_size];
			[[Display sharedDisplay] addDisplayObject:particles onNode:BACK z:0];
		//}
		
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	[super update:dt];
	sprite.rotation += dt * 90.0f;
	//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		particles.position = sprite.position;
}

- (BOOL)execute:(Bipede *)bipede dt:(ccTime)dt {
	if (bipede.currentJumpBase != nil) {
		[self panickBipede:bipede];
	} else {
		[self swallowBipede:bipede];
	}
	return NO;
}

- (void)swallowBipede:(Bipede *)bipede {
	if ([bipede.actioner.currentAction class] != [SwallowByBlackHole class]) {
        SwallowByBlackHole *swallowAction = [[SwallowByBlackHole alloc] initWithBipede:bipede game:game blackHole:self];
		[bipede.actioner setCurrentAction:swallowAction interrupted:YES];
		bipede.sprite.scale = 1.0f;
        [swallowAction release];
	}
}

- (void)panickBipede:(Bipede *)bipede {
	if ([bipede.actioner.currentAction class] == [AvoidDanger class]) {
		[self swallowBipede:bipede];
	} else if ([bipede.actioner.currentAction class] != [SwallowByBlackHole class]) {
        AvoidDanger *avoidDanger = [[AvoidDanger alloc] initWithBipede:bipede game:game dangerPos:sprite.position];
		[bipede.actioner setCurrentAction:avoidDanger interrupted:YES];
        [avoidDanger release];
	}
}

- (BOOL)testCollid:(Bipede *)bipede dt:(ccTime)dt {
	CGFloat distX = sprite.position.x - (bipede.sprite.position.x + bipede.Vx * dt);
	CGFloat distY = sprite.position.y - (bipede.sprite.position.y + bipede.Vy * dt + bipede.sprite.size.height / 2);
	CGFloat distance = sqrtf(powf(distX, 2) + powf(distY, 2));
	return distance < size.width * 0.5f;
}

- (void)dealloc {
	//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		[particles release];
	[super dealloc];
}

@end
