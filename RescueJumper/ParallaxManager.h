//
//  ParallaxManager.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ccTypes.h"

@class ScrollingDisplayObject;

@interface ParallaxManager : NSObject {
	
	ScrollingDisplayObject *sprite;
	CGFloat speed;
	
}

- (id)initWithImg:(NSString *)img offset:(CGFloat)offset speed:(CGFloat)_speed;

- (void)update:(ccTime)dt scrollX:(CGFloat)scrollX;

@end
