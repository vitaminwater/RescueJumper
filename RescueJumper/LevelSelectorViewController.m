//
//  LevelSelectorViewController.m
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelSelectorViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Game.h"

#import "HomeMenu.h"

#import "GameStateActionSurvivalIntro.h"

#import "Display.h"

#import "BaseGameLevel.h"

@interface LevelSelectorViewController ()

@end

@implementation LevelSelectorViewController

- (id)initWithLevels:(NSArray *)_levels
{
    self = [super initWithNibName:@"LevelSelectorViewController" bundle:nil];
    if (self) {
        levels = _levels;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
	winView.layer.cornerRadius = 10;
	

    NSUInteger canPlaySurv = [[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel4Done"] ? 1 : 0;
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"levelbg_ipad.png"]];
        [survivalButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level5_%d_ipad.png", canPlaySurv]] forState:UIControlStateNormal];
    } else {
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"levelbg_iphone.png"]];
        [survivalButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level5_%d_iphone.png", canPlaySurv]] forState:UIControlStateNormal];
    }
#else
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"level5_%d_iphone.png", canPlaySurv]]];
    [survivalButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level5_%d_iphone.png", canPlaySurv]] forState:UIControlStateNormal];
#endif
	headerBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textdanger.png"]];
	titleBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textyell.png"]];
    
    for (UILabel *label in labels) {
		label.font = [UIFont fontWithName:@"AvantGarde" size:label.font.pointSize];
	}
    
    for (NSObject<BaseGameLevel> *gameLevel in levels) {
        NSUInteger index = [levels indexOfObject:gameLevel];
        CGRect frame = CGRectMake(index * (bgView.frame.size.width / [levels count]),
                                  0,
                                  bgView.frame.size.width / [levels count],
                                  148 - (titleBar.frame.origin.y + titleBar.frame.size.height));
        UIButton *levelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [levelButton setImage:[UIImage imageNamed:[gameLevel getLevelIcon]] forState:UIControlStateNormal];
        levelButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        levelButton.frame = frame;
        levelButton.tag = index + 1;
        [levelButton addTarget:self action:@selector(levelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:levelButton];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"frame"] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGRect frame = self.view.frame;
		frame.size = CGSizeMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
		frame.origin = CGPointMake(self.view.frame.size.width / 2 - frame.size.width / 2, self.view.frame.size.height / 2 - frame.size.height / 2);
		winView.frame = frame;
	}
}

- (void)levelSelected:(id)sender {
    NSObject<BaseGameLevel> *gameLevel = [levels objectAtIndex:((UIButton *)sender).tag - 1];
    if (![gameLevel canPlay])
        return;
    [UIView animateWithDuration:0.3 animations:^{
		self.view.alpha = 0.0f;
	} completion:^(BOOL finished) {
        NSNumber *muted = [[NSUserDefaults standardUserDefaults] valueForKey:@"NO_MUSIC"];
        Game *game = [[[Game alloc] initWithNPlayer:1 muted:(muted && [muted boolValue]) || [MPMusicPlayerController iPodMusicPlayer].playbackState == MPMusicPlaybackStatePlaying] autorelease];
        [gameLevel initGame:game];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:game]];
    }];
}

- (IBAction)survivalMode:(id)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GameLevel4Done"])
        return;
    [UIView animateWithDuration:0.3 animations:^{
		self.view.alpha = 0.0f;
	} completion:^(BOOL finished) {
        NSNumber *muted = [[NSUserDefaults standardUserDefaults] valueForKey:@"NO_MUSIC"];
        Game *game = [[[Game alloc] initWithNPlayer:1 muted:(muted && [muted boolValue]) || [MPMusicPlayerController iPodMusicPlayer].playbackState == MPMusicPlaybackStatePlaying] autorelease];
        [game.gameStateActioner setCurrentAction:[[[GameStateActionSurvivalIntro alloc] initWithGame:game] autorelease] interrupted:NO];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:game]];
    }];
}

- (IBAction)backPressed:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
		self.view.alpha = 0.0f;
	} completion:^(BOOL finished) {
        CCScene *homeMenu = [HomeMenu scene];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:homeMenu]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"frame"];
    [winView release];
    [bgView release];
	[headerBar release];
	[titleBar release];
    [labels release];
    [survivalButton release];
    [super dealloc];
}

@end
