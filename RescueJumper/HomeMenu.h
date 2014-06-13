//
//  Menu.h
//  RescueLander
//
//  Created by stant on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __MENU_H
#define __MENU_H

#import "BaseMenu.h"

#import <GameKit/GameKit.h>

@class HomeMenuController;

@interface HomeMenu : BaseMenu {
	
	HomeMenuController *menuController;
	
}

@end

#endif