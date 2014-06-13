//
//  Menu.m
//  RescueLander
//
//  Created by stant on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeMenu.h"
#import "Game.h"

#import "AppDelegate.h"
#import "HomeMenuController.h"
#import "HomeMenuController_Pad.h"
#import "HomeMenuController_Phone.h"

@implementation HomeMenu

-(id)init
{
	if( (self=[super init]) ) {
#ifdef UI_USER_INTERFACE_IDIOM
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			menuController = [[HomeMenuController_Pad alloc] initWithNibName:@"HomeMenuController" bundle:nil];
		else
			menuController = [[HomeMenuController_Phone alloc] initWithNibName:@"HomeMenuController" bundle:nil];
#else
		menuController = [[HomeMenuController_Phone alloc] initWithNibName:@"HomeMenuController" bundle:nil];
#endif
		
		[((AppDelegate *)[UIApplication sharedApplication].delegate) showMenu:menuController player:-1];
	}
	return self;
}

- (void)dealloc
{
	[((AppDelegate *)[UIApplication sharedApplication].delegate) removeMenu:menuController];
	[menuController release];
	[super dealloc];
}

@end
