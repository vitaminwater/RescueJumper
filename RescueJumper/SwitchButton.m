//
//  AutoPlayButt.m
//  CFMVideo
//
//  Created by Constantin CLAUZEL on 3/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SwitchButton.h"

@implementation SwitchButton

@synthesize active;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (self) {
        [self initUI];
	}
	return self;

}

- (void)initUI {
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toggle_track_off.png"]];
	UIImage *img = [UIImage imageNamed:@"toggle_switch.png"];
	switchImg = [[UIImageView alloc] initWithImage:img];
	borderOffset = self.frame.size.height / 2.0f - (img.size.height - 4) / 2.0f;
	switchImg.frame = CGRectMake(-img.size.width / 4.0f, borderOffset, img.size.width, img.size.height);
	[self addSubview:switchImg];
    [switchImg release];
	
	active = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	active = !active;
	[UIView animateWithDuration:0.2 animations:^{
		CGRect frame = switchImg.frame;
		if (active)
			frame.origin.x = self.frame.size.width - switchImg.frame.size.width * 3.0f/4.0f;
		else
			frame.origin.x = -switchImg.frame.size.width / 4.0f;
		switchImg.frame = frame;
	} completion:^(BOOL finished) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:active ? @"toggle_track_on.png" : @"toggle_track_off.png"]];
	}];
}

@end

