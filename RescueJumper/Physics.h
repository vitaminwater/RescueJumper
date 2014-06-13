//
//  Physics.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/2/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NEWTON_G (9.81f * 120.0f)

@interface Physics : NSObject

+ (BOOL)jumpFrom:(CGPoint)from to:(CGPoint)to result:(CGPoint *)result te:(double *)te;

@end
