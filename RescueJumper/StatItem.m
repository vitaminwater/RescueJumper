//
//  StatItem.m
//  RescueJumper
//
//  Created by stant on 9/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "StatItem.h"

@interface StatItem()

- (id)initWithName:(NSString *)_name key:(NSUInteger)_key;

@end

@implementation StatItem

@synthesize name;
@synthesize key;

- (id)initWithName:(NSString *)_name key:(NSUInteger)_key {
    
    if (self = [super init]) {
        name = [_name retain];
        key = _key;
    }
    return self;
    
}

- (void)addItem:(CGFloat)_n pts:(CGFloat)_pts {
    n += _n;
    pts += _pts;
}

- (void)removeItem:(CGFloat)_n pts:(CGFloat)_pts {
    n -= _n;
    pts -= _pts;
}

- (CGFloat)resultN {
    return n;
}

- (CGFloat)resultPts {
    return pts;
}

- (void)clean {
    n = 0;
    pts = 0;
}

+ (id)statItemWithName:(NSString *)_name key:(NSUInteger)_key {
    return [[[self alloc] initWithName:_name key:_key] autorelease];
}

- (void)dealloc {
    [name release];
    [super dealloc];
}

@end
