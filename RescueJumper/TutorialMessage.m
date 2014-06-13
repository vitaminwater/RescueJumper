//
//  TutorialMessage.m
//  RescueJumper
//
//  Created by Constantin on 12/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "TutorialMessage.h"

#import "Display.h"
#import "Screen.h"

#import "ColoredQuad.h"

@interface TutorialMessage() {

CCSprite *bobSprite;
    
}

@end

@implementation TutorialMessage

- (id)initWithString:(NSString *)messageString screen:(NSUInteger)screen {
    
    if (self = [super init]) {
        messageStrings = [[messageString componentsSeparatedByString:@"\n"] retain];
        
        node = [CCNode node];
        [[Display sharedDisplay].screens[screen].rootNode addChild:node];
        
        bobSprite = [CCSprite spriteWithFile:@"message-perso.png"];
        bobSprite.anchorPoint = ccp(0, 0);
        bobSprite.position = ccp(0, -bobSprite.contentSize.height);

        ColoredQuad *coloredQuad = [[ColoredQuad alloc] initWithRect:CGRectMake(0, 0, [Display sharedDisplay].size.width, bobSprite.contentSize.height * 0.7) color:ccc4(0, 0, 0, 127)];
        [node addChild:coloredQuad];
        [coloredQuad release];
        
        messageLabel = [CCLabelBMFont labelWithString:messageString fntFile:@"burgley40.fnt"];
        messageLabel.visible = NO;
        messageLabel.anchorPoint = ccp(0, 0.5);
        messageLabel.scale = 1.0f;
        
        [node addChild:messageLabel];
        
        node.position = ccp(0, -bobSprite.contentSize.height);
        [node addChild:bobSprite];
        
        messageLabel.position = ccp(bobSprite.contentSize.width + 20, bobSprite.contentSize.height * 0.5);
        
    }
    return self;
    
}

- (BOOL)update:(ccTime)dt {
    if ((int)currentChar >= nChar)
        return YES;
    if (node.position.y < 0) {
        CGPoint pos = node.position;
        pos.y += bobSprite.contentSize.height * dt * 5;
        pos.y = pos.y < 0 ? pos.y : 0;
        node.position = pos;
        bobSprite.position = pos;
    } else {
        NSUInteger tmp = (int)currentChar;
        currentChar += dt * 40;
        if ((int)currentChar != tmp) {
            for (++tmp; tmp <= (int)currentChar; ++tmp) {
                ((CCSprite *)[messageLabel getChildByTag:tmp]).opacity = 255;
            }
        }
    }
    return NO;
}

- (BOOL)fillMessage {
    if (currentString >= [messageStrings count])
        return NO;
    NSMutableString *message = [NSMutableString string];
    int i = currentString;
    nChar = 0;
    for (; i < currentString + 2 && i < [messageStrings count]; ++i) {
        if (((NSString *)[messageStrings objectAtIndex:i]).length)
            [message appendFormat:@"\n%@", [messageStrings objectAtIndex:i]];
    }
    currentString = i;
    currentChar = 0;
    nChar = [message length];
    
    messageLabel.string = message;
    messageLabel.visible = YES;
    
    for (int i = 1; i < nChar; ++i)
        ((CCSprite *)[messageLabel getChildByTag:i]).opacity = 0;
    ((CCSprite *)[messageLabel getChildByTag:0]).opacity = 255;
    
    return YES;
}

- (void)dealloc {
    [messageStrings release];
    [node removeFromParentAndCleanup:YES];
    [super dealloc];
}

@end
