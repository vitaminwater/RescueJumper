//
//  StatItem.h
//  RescueJumper
//
//  Created by stant on 9/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatItem : NSObject {
	
	NSString *name;
	NSUInteger key;
	
	CGFloat n;
	CGFloat pts;
	
}

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSUInteger key;

- (void)addItem:(CGFloat)_n pts:(CGFloat)_pts;
- (void)removeItem:(CGFloat)_n pts:(CGFloat)_pts;

- (CGFloat)resultN;
- (CGFloat)resultPts;

- (void)clean;

+ (id)statItemWithName:(NSString *)_name key:(NSUInteger)_key;

@end
