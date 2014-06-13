//
//  DisplayObject.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@interface DisplayObject : NSObject {
	
	CCNode **node;
	NSInteger n;
	
	CGPoint position;
	CGPoint anchor;
	CGSize size;
	CGFloat scale;
	CGFloat scaleX;
	GLubyte opacity;
	ccColor3B color;
	BOOL visible;
	CGFloat rotation;
	
	NSInteger mainScreen;
    
    ccColor3B borderColor;
	
}

@property(nonatomic, readonly)CCNode **node;
@property(nonatomic, readonly)CGSize size;
@property(nonatomic, assign)CGPoint position;
@property(nonatomic, assign)CGPoint anchor;
@property(nonatomic, assign)CGFloat scale;
@property(nonatomic, assign)CGFloat scaleX;
@property(nonatomic, assign)GLubyte opacity;
@property(nonatomic, assign)ccColor3B color;
@property(nonatomic, assign)BOOL visible;
@property(nonatomic, assign)CGFloat rotation;
@property(nonatomic, assign)NSInteger mainScreen;
@property(nonatomic, assign)ccColor3B borderColor;

- (void)addSubDisplayObject:(DisplayObject *)displayObject;

@end
