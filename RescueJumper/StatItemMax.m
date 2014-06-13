//
//  StatItemMax.m
//  RescueJumper
//
//  Created by Constantin on 9/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "StatItemMax.h"

@implementation StatItemMax

- (void)addItem:(CGFloat)_n pts:(CGFloat)_pts {
    [super addItem:_n pts:_pts];
    if (n > nMax) {
        nMax = n;
        ptsMax = pts;
    }
}

- (CGFloat)resultN {
    return nMax;
}

- (CGFloat)resultPts {
    return ptsMax;
}

- (CGFloat)currentN {
	return n;
}

- (void)clean {
    [super clean];
    nMax = 0;
    ptsMax = 0;
}

@end
