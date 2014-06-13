//
//  GreenHole.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/23/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GreenHole.h"

#import "Actioner.h"

#import "Display.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"
#import "ParticleDisplayObject.h"

#import "Game.h"

#import "Bipede.h"
#import "AvoidDanger.h"
#import "Fall.h"

@implementation GreenHole

- (id)initWithGame:(Game *)_game sproutZombiesInterval:(ccTime)_minInterval size:(CGFloat)_size {
	
	if (self = [super initWithGame:_game]) {
		
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"greenhole.png" anchor:ccp(0.5, 0.5) isSpriteFrame:YES];
		_sprite.scale = _size;
		sprite = _sprite;
		size = sprite.size;
		size.width *= _size; size.height *= _size;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BONUS z:0];
		
		//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
			_sprite.opacity = 0.5;
			particles = [[ParticleDisplayObject alloc] initParticleNode:@"greenhole.plist" scale:_size];
			[[Display sharedDisplay] addDisplayObject:particles onNode:BACK z:0];
		//}
        
        minInterval = _minInterval;
        timeToSproutAZombie = _minInterval;
	}
	return self;
	
}

- (void)update:(ccTime)dt {
	[super update:dt];
	sprite.rotation += dt * 90.0f;
	particles.position = sprite.position;
    if (timeToSproutAZombie >= 0) {
        timeToSproutAZombie -= dt;
        if (timeToSproutAZombie <= 0) {
            Bipede *bipede = [[Bipede alloc] initWithJumpBase:nil player:ZOMBIE_PLAYER game:game];
            bipede.sprite.position = self.sprite.position;
            
            Fall *fall = [[Fall alloc] initWithBipede:bipede game:game];
            [bipede.actioner setCurrentAction:fall interrupted:YES];
            [fall release];

            bipede.Vx = (rand() % 500) - 250.0f;
            bipede.Vy = (CGFloat)(rand() % 300) + 300.0f;
            bipede.sprite.scaleX = bipede.Vx > 0 ? 1.0f : -1.0f;

            [game.pnjs addEntry:bipede];
            [bipede release];
            
            timeToSproutAZombie = (rand() % 5) + minInterval;
        }
    }
}

- (BOOL)execute:(Bipede *)bipede dt:(ccTime)dt {
	if (bipede.player == ZOMBIE_PLAYER)
		return NO;
	if (bipede.currentJumpBase != nil) {
		[self panickBipede:bipede];
	} else {
		CGFloat bVx = bipede.Vx;
		CGFloat bVy = bipede.Vy;
        Fall *fall = [[Fall alloc] initWithBipede:bipede game:game];
		[self transformBipede:bipede];
        [bipede displayMessage:@"Derp !" scale:1.0f color:ccc3(100, 255, 100)];
		bipede.Vx = bVx;
		bipede.Vy = bVy;
		[bipede.actioner setCurrentAction:fall interrupted:YES];
        [fall release];
	}
	return YES;
}

- (void)transformBipede:(Bipede *)bipede {
	[bipede convertToPlayer:ZOMBIE_PLAYER];
}

- (void)panickBipede:(Bipede *)bipede {
	if (![bipede.actioner.currentAction isKindOfClass:[AvoidDanger class]]) {
        AvoidDanger *avoidDanger = [[AvoidDanger alloc] initWithBipede:bipede game:game dangerPos:sprite.position];
		[bipede.actioner setCurrentAction:avoidDanger interrupted:YES];
        [avoidDanger release];
	} else {
		[self transformBipede:bipede];
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
