//
//  ScrollingDisplayObject.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ScrollingDisplayObject.h"
#import "cocos2d.h"

@implementation ScrollingDisplayObject

- (id)initSprite:(NSString *)img anchor:(CGPoint)_anchor isSpriteFrame:(BOOL)isSpriteFrame size:(CGSize)_size {
	
	if (self = [super initSprite:img anchor:_anchor isSpriteFrame:isSpriteFrame]) {
		ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT };
		for (int i = 0; i < n; ++i) {
			[((CCSprite *)node[i]).texture setTexParameters:&params];
            ((CCSprite *)node[i]).textureRect = CGRectMake(0, 0, _size.width > 0 ? _size.width : ((CCSprite *)node[i]).textureRect.size.width, _size.height > 0 ? _size.height : ((CCSprite *)node[i]).textureRect.size.height);
        }
	}
	return self;
}

- (void)scrollTextureX:(CGFloat)scrollX Y:(CGFloat)scrollY {
	for (int i = 0; i < n; ++i)
		((CCSprite *)node[i]).textureRect = CGRectMake(((CCSprite *)node[i]).textureRect.origin.x + scrollX,
										   ((CCSprite *)node[i]).textureRect.origin.y + scrollY,
										   ((CCSprite *)node[i]).textureRect.size.width,
										   ((CCSprite *)node[i]).textureRect.size.height);
}

- (void)setColor:(ccColor3B)_color {
	color = _color;
	for (int i = 0; i < n; ++i) {
		[((CCSprite *)node[i]) setColor:color];
	}
}

@end
