//
//  HomeMenuController.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GameCenterManager.h"

@class SwitchButton;

@interface HomeMenuController : UIViewController<GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate> {
	
	IBOutlet UIView *bgView;
	IBOutlet UIView *headerBar;
	IBOutlet UIView *titleBar;
    
    IBOutlet UIButton *muteButt;
	
	IBOutlet UIButton *onePlayer;
	IBOutlet UIButton *twoPlayer;
    
    IBOutlet UIView *resetHelpView;
	IBOutlet SwitchButton *resetHelpButt;
	
	IBOutletCollection(UILabel) NSArray *labels;
	
	NSMutableArray *scores;
	NSMutableArray *players;
	
	IBOutlet UITableView *tableView;
	
	BOOL muted;
    
}

@property(nonatomic, assign)IBOutlet UITableViewCell *tmpCell;

@end
