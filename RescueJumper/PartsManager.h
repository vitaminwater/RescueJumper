//
//  PartsManager.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/4/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartsManager : NSObject {
	
	@public
	NSUInteger nParts;
	NSUInteger partSize;

	@private
	CGFloat *partsHP;
	
}

- (id)initWithNParts:(NSUInteger)_nParts partSize:(NSUInteger)_partSize partsHP:(NSUInteger)_partsHP;
- (BOOL)hit:(NSUInteger)position force:(CGFloat)force resultingBlock:(void(^)(NSUInteger position, NSUInteger size))resultingBlock;

@end
