//
//  BubbledLabelBMFont.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 7/13/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BubbledLabelBMFont.h"

@implementation BubbledLabelBMFont

- (id)initWithFntFile:(NSString *)fntFile text:(NSString *)_text {

	if (self = [super init]) {
		bubble[0] = [CCSprite spriteWithFile:@"bg_speak_1.png"];
		bubble[0].anchorPoint = ccp(1.0f, 0.5f);
		
		bubble[1] = [CCSprite spriteWithFile:@"bg_speak_2.png"];
		bubble[1].anchorPoint = ccp(0.5f, 0.5f);
		
		bubble[2] = [CCSprite spriteWithFile:@"bg_speak_3.png"];
		bubble[2].anchorPoint = ccp(0.0f, 0.5f);
		
		text = [CCLabelBMFont labelWithString:@"" fntFile:fntFile];
		text.anchorPoint = ccp(0.5f, 0.4f);
		
		for (int i = 0; i < 3; ++i) [self addChild:bubble[i]];
		
		[self addChild:text];
		
		[self setText:_text];
		totalSize = CGSizeMake(bubble[0].contentSize.width + text.contentSize.width + bubble[2].contentSize.width, bubble[2].contentSize.height);
	}
	return self;
	
}

- (void)setText:(NSString *)_text {
	text.string = _text;
	totalSize = CGSizeMake(bubble[0].contentSize.width + text.contentSize.width + bubble[2].contentSize.width, bubble[2].contentSize.height);
	text.position = ccp(-totalSize.width * self.anchorPoint.x + totalSize.width / 2, -totalSize.height * self.anchorPoint.y);
	bubble[0].position = ccp(-text.contentSize.width / 2.0f + 1 - totalSize.width * self.anchorPoint.x + totalSize.width / 2, -totalSize.height * self.anchorPoint.y);
	bubble[1].position = text.position;
	bubble[1].scaleX = text.contentSize.width / bubble[1].contentSize.width;
	bubble[2].position = ccp(text.contentSize.width / 2.0f - 2 - totalSize.width * self.anchorPoint.x + totalSize.width / 2, -totalSize.height * self.anchorPoint.y);
}

- (void)setOpacity:(GLubyte)opacity {
	for (int i = 0; i < 3; ++i) bubble[i].opacity = opacity;
}

- (void)setColor:(ccColor3B)color {
	for (int i = 0; i < 3; ++i) bubble[i].color = color;
}

- (void) setAnchorPoint:(CGPoint)anchorPoint {
	[super setAnchorPoint:anchorPoint];
	[self setText:text.string];
}

- (void)setScale:(float)scale {
	self.position = ccpAdd(self.position, ccp((totalSize.width * scale - totalSize.width * self.scale) / 2, (totalSize.height * scale - totalSize.height * self.scale) / 2));
	[super setScale:scale];
}

- (void)dealloc {
	[super dealloc];
}

@end
