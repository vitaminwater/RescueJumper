//
//  Missile.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ccTypes.h"

#import "MBDACenter.h"

@class StaticDisplayObject;
@class ParticleDisplayObject;

@interface Missile : NSObject {
	
	NSUInteger player;
	
	StaticDisplayObject *sprite;
	ParticleDisplayObject *particles;
	
	NSObject<MissilAim> *aim;
    CGPoint aimPos;
	CGFloat Vx;
	CGFloat Vy;
	
}

@property(nonatomic, readonly)StaticDisplayObject *sprite;
@property(nonatomic, assign)NSObject<MissilAim> *aim;
@property(nonatomic, readonly)CGFloat Vx;
@property(nonatomic, readonly)CGFloat Vy;
@property(nonatomic, assign)NSUInteger player;

- (id)initWithSprite:(NSString *)_sprite aim:(NSObject<MissilAim> *)_aim source:(CGPoint)source direction:(CGPoint)direction;
- (void)update:(ccTime)dt;

@end
