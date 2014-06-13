//
//  Tourelle.m
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Tourelle.h"

#import "Display.h"
#import "DisplayObject.h"
#import "StaticDisplayObject.h"

#import "Game.h"

#import "MBDACenter.h"
#import "MissilLauncher.h"
#import "Missile.h"

@implementation Tourelle

- (id)initWithGame:(Game *)_game player:(NSUInteger)_player {
    
	if (self = [super initWithGame:_game]) {
        
        lastAim = nil;
		
		StaticDisplayObject *_sprite = [[StaticDisplayObject alloc] initSprite:@"tourelle.png" anchor:ccp(0.55f, 1.0f) isSpriteFrame:NO];
        _sprite.position = ccp([Display sharedDisplay].size.width + _sprite.size.width / 2 - [Display sharedDisplay].scrollX, [Display sharedDisplay].size.height - 32);
        sprite = _sprite;
        
        gun = [[StaticDisplayObject alloc] initSprite:@"canon.png" anchor:ccp(0.30f, 0.55f) isSpriteFrame:NO];
        gun.position = ccpAdd(sprite.position, ccp(0, -35.0f));
        
        launcher = [[MissilLauncher alloc] initWithPosition:gun.position direction:ccp(0, 0)];
		launcher.player = _player;
        [[MBDACenter sharedMBDACenter].launchers addEntry:launcher];
        [launcher release];
        
        [[Display sharedDisplay] addDisplayObject:gun onNode:BACK z:0];
        [[Display sharedDisplay] addDisplayObject:sprite onNode:BACK z:0];
		
	}
	return self;
    
}

- (void)update:(ccTime)dt {
    if (sprite.position.x > [Display sharedDisplay].size.width / 2 - [Display sharedDisplay].scrollX || time > 10.0f)
        Vx = -game.scrollSpeed * 2.0f;
    else
        Vx = game.scrollSpeed;
    
    if ([[MBDACenter sharedMBDACenter].aims count]) {
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
    }
    
    [super update:dt];
    gun.position = ccpAdd(sprite.position, ccp(0, -35.0f));

    if ([launcher.aims count]) {
        if (launcher.nextAim && launcher.nextAim != lastAim) {
            NSObject<MissilAim> *aim = launcher.nextAim;
            CGFloat dist = sqrtf(powf([aim aimPosition].x - gun.position.x, 2.0f) + powf([aim aimPosition].y - gun.position.y, 2.0f));
            angle = acosf(([aim aimPosition].x - gun.position.x) / dist);
            
            launcherOffset.x = ([aim aimPosition].x - gun.position.x) / dist * 64.0f;
            launcherOffset.y = ([aim aimPosition].y - gun.position.y) / dist * 64.0f;
            lastAim = aim;
        }

        launcher.position = ccpAdd(gun.position, launcherOffset);
        launcher.direction = ccpMult(launcherOffset, 10);
        gun.rotation += ((angle / M_PI * 180.0f) < gun.rotation ? -1.0f : 1.0f) * 90.0f * dt;
    } else {
        gun.rotation = cosf(time * 3.0f) * 45.0f + 90.0f;
    }
    
    time += dt;
}

- (CGRect)collidRect {
    return CGRectMake(sprite.position.x - sprite.size.width / 2, sprite.position.y - sprite.size.height, sprite.size.width, sprite.size.height);
}

- (void)dealloc {
    [[MBDACenter sharedMBDACenter].launchers iterateOrRemove:^BOOL(id entry) {
		return entry == launcher;
	} removeOnYES:YES exit:YES];
    [gun release];
    [super dealloc];
}

@end
