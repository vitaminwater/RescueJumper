//
//  HelpScreen.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/28/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

#import "HelpScreen.h"
#import "Display.h"
#import "StaticDisplayObject.h"

@implementation HelpScreen

- (id)init {
	
	if (self = [super init]) {
		
		UIDevice* thisDevice = [UIDevice currentDevice];
        if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad && [Display sharedDisplay].n < 2)
			sprite = [[StaticDisplayObject alloc] initSprite:@"help-hd.png" anchor:ccp(0.5, 0.5) isSpriteFrame:NO];
        else
			sprite = [[StaticDisplayObject alloc] initSprite:@"help.png" anchor:ccp(0.5, 0.5) isSpriteFrame:NO];
		sprite.position = ccp([Display sharedDisplay].screenSize.width / 2, [Display sharedDisplay].screenSize.height / 2);
		[[Display sharedDisplay] addDisplayObject:sprite onNode:NOSCALE z:0];
		
	}
	return self;
	
}

- (void)dealloc {
	[sprite release];
	[super dealloc];
}

@end
