//
//  LevelSelectorMenu.h
//  RescueJumper
//
//  Created by Constantin on 12/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BaseMenu.h"

@class LevelSelectorViewController;

@interface LevelSelectorMenu : BaseMenu {
    
    LevelSelectorViewController *levelSelectorViewController;
    NSMutableArray *levels;
    
}

@end
