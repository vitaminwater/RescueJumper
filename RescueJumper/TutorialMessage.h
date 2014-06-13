//
//  TutorialMessage.h
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@interface TutorialMessage : NSObject {
    
    CCNode *node;
    
    CCLabelBMFont *messageLabel;
    NSArray *messageStrings;
    NSUInteger currentString;
    CGFloat currentChar;
    NSUInteger nChar;
}

- (id)initWithString:(NSString *)messageString screen:(NSUInteger)screen;
- (BOOL)update:(ccTime)dt;
- (BOOL)fillMessage;

@end
