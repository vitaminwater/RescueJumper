//
//  MBDACenter.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KSSingleton.h"

#import "ccTypes.h"

@class Missile;
@class ChainList;

@protocol MissilAim <NSObject>

@property(nonatomic, readonly)NSInteger player;

- (CGPoint)aimPosition;
- (BOOL)hitAndRemove:(Missile *)missile;

@end

@interface MBDACenter : NSObject {

	ChainList *aims;
	ChainList *missils;
	ChainList *launchers;

}

KS_SINGLETON_INTERFACE(MBDACenter)


@property(nonatomic, readonly)ChainList *aims;
@property(nonatomic, readonly)ChainList *launchers;

- (void)update:(ccTime)dt;
- (void)addMissile:(NSObject<MissilAim> *)aim source:(CGPoint)source direction:(CGPoint)direction player:(NSUInteger)player;

+ (void)reset;

@end
