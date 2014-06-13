//
//  TextDisplayObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/9/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "DisplayObject.h"

@interface TextDisplayObject : DisplayObject {
	
	NSString *string;
	
}

@property(nonatomic, assign)NSString *string;

- (id)initWithFont:(NSString *)fntFile anchor:(CGPoint)_anchor text:(NSString *)text;

@end
