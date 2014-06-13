//
//  MotherShip.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "MotherShip.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"
#import "cocos2d.h"

#import "Display.h"
#import "Game.h"
#import "PlayerData.h"

#import "Bipede.h"
#import "Actioner.h"
#import "EnterMotherShip.h"

#import "Scores.h"

#import "MBDACenter.h"
#import "MissilLauncher.h"

#import "ParticleDisplayObject.h"

@implementation MotherShip

- (id)initWithGame:(Game *)_game {
	
	if (self = [super initWithGame:_game]) {
		
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"bigvaisseau.png" anchor:ccp(0.5, 0.0) isSpriteFrame:NO];
		//[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
		_sprite.position = ccp(-[Display sharedDisplay].scrollX +
							   [Display sharedDisplay].size.width +
							   _sprite.size.width / 2, 0);
		
		sprite = _sprite;
		size = sprite.size;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:BLOCK_BACK z:-1];
		
		scanDelay = 2;
		active = YES;
        moveEntryPoints = YES;
		
		launcher = [[MissilLauncher alloc] initWithPosition:ccpAdd(sprite.position, ccp(0, sprite.size.height / 2)) direction:ccp(0, 800)];
		[[MBDACenter sharedMBDACenter].launchers addEntry:launcher];
        [launcher release];
		
		//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
			particles[0] = [[ParticleDisplayObject alloc] initParticleNode:@"smoke-bigship.plist" scale:1.0];
			particles[0].position = ccp(74, 170);
			[sprite addSubDisplayObject:particles[0]];
			
			particles[1] = [[ParticleDisplayObject alloc] initParticleNode:@"smoke-bigship.plist" scale:1.0];
			particles[1].position = ccp(137, 170);
			[sprite addSubDisplayObject:particles[1]];

			particles[2] = [[ParticleDisplayObject alloc] initParticleNode:@"smoke-bigship.plist" scale:1.0];
			particles[2].position = ccp(883, 65);
			[sprite addSubDisplayObject:particles[2]];
		//}
        shakeForce = 0;
	}
	return self;
	
}

- (void)bipedeAdded:(Bipede *)bipede {
	[super bipedeAdded:bipede];
	if (bipede.player < game.nPlayer) {
		CGPoint scorePos = bipede.sprite.position;
		scorePos.y += bipede.sprite.size.height;
        [game.playerData[bipede.player] addStat:STAT_END_HUMAN n:1 pts:END_SCORE];
		[game addScore:END_SCORE player:bipede.player pos:scorePos];
	}
}

- (void)update:(ccTime)dt {
    /*if (sprite.position.x - sprite.size.width / 2 > -[Display sharedDisplay].scrollX) {
        Vx = -10.0f;
    } else
        Vx = game.scrollSpeed;*/
    
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
    launcher.position = ccpAdd(sprite.position, ccp(0, sprite.size.height / 2));
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - sprite.size.width / 2, sprite.position.y + 80, 995, 20 + 40);
}

- (CGFloat)touchHeightAdded {
    return 40.0f;
}

- (NSUInteger)type {
    return JUMPBASE_MOTHERSHIP;
}

- (void)dealloc {
	//if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		for (int i = 0; i < 3; ++i) {
			[particles[i] release];
		}
	//}
	[[MBDACenter sharedMBDACenter].launchers iterateOrRemove:^BOOL(id entry) {
		return entry == launcher;
	} removeOnYES:YES exit:YES];
	[super dealloc];
}

@end
