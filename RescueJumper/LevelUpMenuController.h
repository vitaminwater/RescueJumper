//
//  LevelUpController.h
//  RescueJumper
//
//  Created by Constantin on 5/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"

@class Game;
@class SurvivalGameData;
@class GameStateActionLevelUp;
@class SwitchButton;

@protocol LevelUpMenuControllerDelegate <NSObject>

- (void)startNextLevel:(id)sender;

@end

@interface LevelUpMenuController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate> {
	
	IBOutlet UIView *bgView;
	IBOutlet UIView *titleBar;
	
    IBOutlet UILabel *readyFor;
    IBOutlet UILabel *showTutorial;
    IBOutlet UILabel *clockPicked;
    
	IBOutlet UILabel *levelTitle;
	IBOutlet UILabel *levelNumber;
	IBOutlet UILabel *levelTime;
	IBOutlet UIImageView *timeIcon;
    
    IBOutlet UIView *shopHeaderView;
    IBOutlet UILabel *coinLabel;
    IBOutlet UIView *shopTitleBar;
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
    IBOutlet UIPanGestureRecognizer *panGesture;
	
    IBOutlet UIButton *goButton;
    
	IBOutletCollection(UILabel) NSArray *labels;
	IBOutletCollection(UIView) NSArray *headerBars;

	IBOutlet UIView *bgClockGuys;
	IBOutlet UIView *clockGuys;
	IBOutlet UILabel *clockGuysLabel;
	ccTime time;
	NSUInteger totalClockGuys;
	BOOL blockGuiesProc;
		
	Game *game;
    SurvivalGameData *gameData;
	NSUInteger player;
	NSObject<LevelUpMenuControllerDelegate> *delegate;
	
    NSArray *levelHelpers;
    NSMutableArray *shopItems;
	CGFloat currentPage;
    
}

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player delegate:(NSObject<LevelUpMenuControllerDelegate> *)_delegate levelHelpers:(NSArray *)_levelHelpers;
- (void)update:(ccTime)dt;
- (CGRect)clockPosition:(NSUInteger)index total:(NSUInteger)total;
- (void)updateShops;
- (void)updateShopHeader;

@end
