//
//  BorderedCCSprite.m
//  RescueJumper
//
//  Created by Constantin on 10/10/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BorderedCCSprite.h"

@implementation BorderedCCSprite

@synthesize borderColor;

- (void)draw {
    if (borderColor.r || borderColor.g || borderColor.b) {
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glColor4ub(borderColor.r, borderColor.g, borderColor.b, self.opacity);
        glLineWidth(1);

        ccDrawLine(ccp(0, self.contentSize.height - 1),
                   ccp(self.contentSize.width, self.contentSize.height - 1));

        ccDrawLine(ccp(0, self.contentSize.height - 2),
                   ccp(self.contentSize.width, self.contentSize.height - 2));

        ccDrawLine(ccp(self.contentSize.width, 1),
                   ccp(0, 1));
        ccDrawLine(ccp(self.contentSize.width, 2),
                   ccp(0, 2));
        glColor4ub(255, 255, 255, 255);
        glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
    }
    [super draw];
}

@end
