//
//  BaseMenu.m
//  RescueLander
//
//  Created by stant on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseMenu.h"


@implementation BaseMenu

+(id) scene
{
	CCScene *scene = [CCScene node];
	
	BaseMenu *layer = [[self class] node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {

        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
		
		NSString *splashFile = nil;
		
#ifdef UI_USER_INTERFACE_IDIOM
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			splashFile = [NSString stringWithFormat:@"Default-Landscape%@~ipad.png", ([CCDirector sharedDirector].contentScaleFactor == 2 ? @"@2x" : @"")];
		else {
			CGSize winSize = [UIScreen mainScreen].bounds.size;
			if (winSize.height > 480)
				splashFile = [NSString stringWithFormat:@"Default-568h@2x.png"];
			else
				splashFile = [NSString stringWithFormat:@"Default%@.png", ([CCDirector sharedDirector].contentScaleFactor == 2 ? @"@2x" : @"")];
		}
#else
		CGSize winSize = [UIScreen mainScreen].bounds.size;
		if (winSize.height > 480)
			splashFile = [NSString stringWithFormat:@"Default-568h@2x.png"];
		else
			splashFile = [NSString stringWithFormat:@"Default%@.png", ([CCDirector sharedDirector].contentScaleFactor == 2 ? @"@2x" : @"")];
#endif
		
		CCSprite *bg = [CCSprite spriteWithFile:splashFile];
#ifdef UI_USER_INTERFACE_IDIOM
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
			bg.rotation = 90;
			bg.position = ccp(bg.contentSize.height / 2, bg.contentSize.width / 2);
		} else
			bg.position = ccp(bg.contentSize.width / 2, bg.contentSize.height / 2);
#else
		bg.rotation = 90;
		bg.position = ccp(bg.contentSize.height / 2, bg.contentSize.width / 2);
#endif
        
		bg.anchorPoint = ccp(0.5, 0.5);
		[self addChild:bg z:-1];
		
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
			[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
		else
			[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
		
	}
	return self;
}

-(void)dealloc
{
	[self unschedule:@selector(onEnterFrame:)];
	[super dealloc];
}

@end
