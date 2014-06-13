//
//  LevelSelectorViewController.h
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;

@interface LevelSelectorViewController : UIViewController {

    NSArray *levels;
    
    IBOutlet UIView *winView;
    IBOutlet UIView *bgView;
    IBOutlet UIView *headerBar;
    IBOutlet UIView *titleBar;
    IBOutletCollection(UILabel) NSArray *labels;
    
    IBOutlet UIButton *survivalButton;
    
}

- (id)initWithLevels:(NSArray *)_levels;

@end
