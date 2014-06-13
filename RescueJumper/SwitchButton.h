//
//  AutoPlayButt.h
//  CFMVideo
//
//  Created by Constantin CLAUZEL on 3/1/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchButton : UIView {
	
	UIImageView *switchImg;
	
	CGFloat borderOffset;
	
	BOOL active;
	
}

@property(nonatomic, assign)BOOL active;

@end
