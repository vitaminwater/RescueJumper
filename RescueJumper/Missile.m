//
//  Missile.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Missile.h"

#import "ChainList.h"

#import "Display.h"
#import "Screen.h"
#import "StaticDisplayObject.h"
#import "ParticleDisplayObject.h"

#import "Physics.h"

#import "Game.h"

#import "SimpleAudioEngine.h"

@implementation Missile

@synthesize sprite;
@synthesize aim;
@synthesize Vx;
@synthesize Vy;
@synthesize player;

- (id)initWithSprite:(NSString *)_sprite aim:(NSObject<MissilAim> *)_aim source:(CGPoint)source direction:(CGPoint)direction {
	
	if (self = [super init]) {
		player = NEUTRAL_PLAYER;

		sprite = [[StaticDisplayObject alloc] initSprite:_sprite anchor:ccp(0.5, 0.5) isSpriteFrame:NO];
		sprite.position = source;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:FRONT z:0];
		
		particles = [[ParticleDisplayObject alloc] initParticleNode:@"rocket.plist" scale:1.0];
		particles.position = ccp(0, 0);
		[[Display sharedDisplay] addDisplayObject:particles onNode:FRONT z:0];

		aim = _aim;
        aimPos = [aim aimPosition];
		Vx = direction.x; Vy = direction.y; // 0, 800
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    static NSDictionary *explodeDict = nil;
    if (aim)
        aimPos = [aim aimPosition];
	CGFloat diffX = aimPos.x - sprite.position.x;
	CGFloat diffY = aimPos.y - sprite.position.y;
	CGFloat dist = sqrtf(diffX * diffX + diffY * diffY);
	Vx += ((diffX / dist * 500) - Vx) / 10;
	Vy += ((diffY / dist * 500) - Vy) / 10;
	
	CGFloat angle = atanf(Vy / Vx);
	CGFloat normalizer = sqrtf(Vx * Vx + Vy * Vy);
	sprite.rotation = -angle / M_PI * 180.0f + (Vx > 0 ? 180.0f : 0.0f);
	particles.angle = -sprite.rotation;
	sprite.position = ccpAdd(sprite.position, ccp(Vx * dt, Vy * dt));
	particles.sourcePosition = ccpAdd(sprite.position, ccp(-Vx/normalizer * sprite.size.width / 2, -Vy/normalizer * sprite.size.width / 2));
	if (fabs(sprite.position.x - aimPos.x) < 20 && fabs(sprite.position.y - aimPos.y) < 20) {
		[[MBDACenter sharedMBDACenter].aims iterateOrRemove:^BOOL(id entry) {
			NSObject<MissilAim> *_aim = entry;
			CGPoint pos = [_aim aimPosition];
			if (fabs(pos.x - sprite.position.x) <= 50 && fabs(pos.y - sprite.position.y) <= 50) {
				return [_aim hitAndRemove:self];
			}
			return NO;
		} removeOnYES:YES exit:NO];
        if (!explodeDict)
            explodeDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"missile_explode" ofType:@"plist"]] retain];
        [[Display sharedDisplay] spawnParticleDict:explodeDict pos:sprite.position];
        [[Display sharedDisplay] shakeScreens:5];
		[[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
		sprite.visible = NO;
	}
}

- (void)dealloc {
	[particles release];
	[sprite release];
	[super dealloc];
}

@end
