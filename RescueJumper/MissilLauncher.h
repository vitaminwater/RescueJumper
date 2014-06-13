//
//  MissilLauncher.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/3/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ccTypes.h"

@class ChainList;
@protocol MissilAim;

@interface MissilLauncher : NSObject {
	
	CGPoint position;
    CGPoint direction;
	
	ccTime shootDelay;
	NSUInteger player;
	
	ChainList *aims;
	NSObject<MissilAim> *nextAim;
    
	NSInteger current;
	
}

@property(nonatomic, readonly)ChainList *aims;
@property(nonatomic, readonly)NSObject<MissilAim> *nextAim;
@property(nonatomic, assign)NSUInteger player;
@property(nonatomic, assign)CGPoint position;
@property(nonatomic, assign)CGPoint direction;

- (id)initWithPosition:(CGPoint)_position direction:(CGPoint)_direction;
- (void)update:(ccTime)dt;
- (void)addAim:(NSObject<MissilAim> *)aim;

@end
