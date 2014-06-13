//
//  ScrollingDisplayObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "StaticDisplayObject.h"

@interface ScrollingDisplayObject : StaticDisplayObject

- (id)initSprite:(NSString *)img anchor:(CGPoint)_anchor isSpriteFrame:(BOOL)isSpriteFrame size:(CGSize)size;
- (void)scrollTextureX:(CGFloat)scrollX Y:(CGFloat)scrollY;

@end
