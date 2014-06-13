//
//  BubbledLabelBMFont.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/13/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@interface BubbledLabelBMFont : CCNode {
	
	CGSize totalSize;
	
	CCSprite *bubble[3];
	CCLabelBMFont *text;
	
}

- (id)initWithFntFile:(NSString *)fntFile text:(NSString *)_text;
- (void)setText:(NSString *)_text;
- (void)setOpacity:(GLubyte)opacity;
- (void)setColor:(ccColor3B)color;

@end
