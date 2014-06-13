//
//  LevelEndViewController.h
//  RescueJumper
//
//  Created by Constantin on 12/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelEndViewController : UIViewController {
    
    IBOutlet UIView *bgView;
    IBOutlet UIView *headerBar;
    IBOutlet UIView *titleBar;
    
    IBOutlet UIView *skyView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *descrLabel;
    IBOutlet UIButton *backButt;
    IBOutletCollection(UIImageView)NSArray *stars;
    
    NSString *titleMess;
    NSString *message;
    NSUInteger grade;
    
}

- (id)initWithTitle:(NSString *)_titleMess message:(NSString *)_message grade:(NSUInteger)_grade;

@end
