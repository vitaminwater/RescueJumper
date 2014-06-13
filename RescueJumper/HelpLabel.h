//
//  HelpLabel.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ccTypes.h"

@class StaticDisplayObject;
@class LevelElement;

@protocol HelpHolder;

@interface HelpLabel : NSObject {
	
	StaticDisplayObject *sprite;
	NSObject<HelpHolder> *holder;
	
	GLubyte opacity;
	
	ccTime timeLeft;
	
}

@property(nonatomic, readonly)StaticDisplayObject *sprite;
@property(nonatomic, assign)NSObject<HelpHolder> *holder;

- (id)initWithSpriteFrameName:(NSString *)frameName holder:(NSObject<HelpHolder> *)_holder;
- (void)update:(ccTime)dt;
- (void)hide;
- (CGRect)rect;

@end
