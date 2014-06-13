//
//  ScoreMenuController.h
//  RescueJumper
//
//  Created by Constantin on 5/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ccTypes.h"

#import "Facebook.h"

#import <GameKit/GameKit.h>

@class Game;
@class SurvivalGameData;
@class GameStateActionEnd;

@interface ScoreMenuController : UIViewController<UITableViewDataSource, UITableViewDelegate, GKLeaderboardViewControllerDelegate, FBDialogDelegate> {
    
    IBOutlet UIView *bgView;
	IBOutlet UIView *headerBar;
	IBOutlet UIView *titleBar;
    
    IBOutlet UIView *totalView;
    IBOutlet UILabel *totalLabel;
	
	IBOutlet UITableView *tableView;
    
	IBOutletCollection(UILabel) NSArray *labels;
	
	IBOutlet UIButton *retryButt;
    
    IBOutletCollection(UIButton) NSArray *shareButts;
	
	IBOutlet UIView *scoreView;
	IBOutlet UILabel *scoreLabel;
	IBOutlet UILabel *moodLabel;
	
    Game *game;
    SurvivalGameData *gameData;
	GameStateActionEnd *gameStateActionEnd;
    
	CGFloat totalScore;
    CGFloat totalScoreDisplay;
	
	NSNumberFormatter *numberFormatter;
    
}

@property(nonatomic, assign)IBOutlet UITableViewCell *tmpCell;
@property(nonatomic, assign)NSUInteger player;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player gameStateActionEnd:(GameStateActionEnd *)_gameStateActionEnd;
- (void)update:(ccTime)dt;

@end
