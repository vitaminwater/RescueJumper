//
//  HomeMenuController.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/17/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HomeMenuController.h"

#import "cocos2d.h"
#import "AppDelegate.h"
#import "Game.h"

#import "SwitchButton.h"

#import "LevelSelectorMenu.h"

#import "GameStateActionSurvivalIntro.h"

#import <QuartzCore/QuartzCore.h>

@interface HomeMenuController ()

- (void)checkResetHelp;

@end

@implementation HomeMenuController

@synthesize tmpCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        scores = [[NSMutableArray array] retain];
		players = [[NSMutableArray array] retain];
		muted = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GameCenterManager sharedGameCenterManager] setDelegate:self];
	[[GameCenterManager sharedGameCenterManager] reloadHighScoresForCategory:SCORE_LEADERBOARD];
	
	[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	
	bgView.layer.cornerRadius = 10;
	
	bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textbg.png"]];
	headerBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textdanger.png"]];
	titleBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textyell.png"]];
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
		twoPlayer.hidden = YES;
	} else {
		CGRect frame = twoPlayer.frame;
		frame.origin.y += onePlayer.frame.size.height * 1.2f;
		twoPlayer.frame = frame;
	}
	
	for (UILabel *label in labels) {
		label.font = [UIFont fontWithName:@"AvantGarde" size:label.font.pointSize];
	}
    
    muted = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"NO_MUSIC"] boolValue];
	muteButt.alpha = muted ? 0.5f : 1.0f;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"frame"] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGRect frame = self.view.frame;
		frame.size = CGSizeMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
		frame.origin = CGPointMake(self.view.frame.size.width / 2 - frame.size.width / 2, self.view.frame.size.height / 2 - frame.size.height / 2);
		bgView.frame = frame;
		
	}
}

- (void)viewDidLayoutSubviews {
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

- (IBAction)onePlayer:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
		self.view.alpha = 0.0f;
	} completion:^(BOOL finished) {
        [[CCDirector sharedDirector] replaceScene:[LevelSelectorMenu scene]];
    }];
    [self checkResetHelp];
}

- (IBAction)twoPlayers:(id)sender {
	[UIView animateWithDuration:0.3 animations:^{
		self.view.alpha = 0.0f;
	} completion:^(BOOL finished) {
		Game *game = [[[Game alloc] initWithNPlayer:2 muted:muted || [MPMusicPlayerController iPodMusicPlayer].playbackState == MPMusicPlaybackStatePlaying] autorelease];
        [game.gameStateActioner setCurrentAction:[[[GameStateActionSurvivalIntro alloc] initWithGame:game] autorelease] interrupted:NO];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:game]];
	}];
    [self checkResetHelp];
}

- (void)checkResetHelp {
    if (resetHelpButt.active) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WelcomeTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ClockTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PlateformeTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SaveSiblingsTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShipTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CrowdedPlateformeTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HospitalTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShopTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TimeOutTutorial"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AllDeadTutorial"];

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GameLevel1TutoShown"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GameLevel2TutoShown"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GameLevel3TutoShown"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GameLevel4TutoShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (IBAction)showGameCenter:(id)sender {
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	
    if (leaderboardController != nil)
    {
        leaderboardController.category = SCORE_LEADERBOARD;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
        [self presentModalViewController:leaderboardController animated:YES];
        [leaderboardController release];
    }
}

- (IBAction)showWebSite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rescuejumper.com"]];
}

- (IBAction)toggleMusic:(id)sender {
	muted = !muted;
	((UIButton *)sender).alpha = muted ? 0.5f : 1.0f;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:muted] forKey:@"NO_MUSIC"];
}

- (IBAction)selectMusic:(id)sender {
}

// Media picker delegate methods
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[[MPMusicPlayerController iPodMusicPlayer] setQueueWithItemCollection:mediaItemCollection];
	[[MPMusicPlayerController iPodMusicPlayer] play];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error {
	[scores removeAllObjects];
	[players removeAllObjects];
	
	[scores addObjectsFromArray:leaderBoard.scores];
	NSArray *tmp = [leaderBoard.scores valueForKeyPath:@"@unionOfObjects.playerID"];
	[GKPlayer loadPlayersForIdentifiers:tmp withCompletionHandler:^(NSArray *_players, NSError *error) {
		[players addObjectsFromArray:_players];
		[tableView reloadData];
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [scores count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	GKPlayer *currentPlayer = [players objectAtIndex:indexPath.row];
	GKScore *currentScore = [scores objectAtIndex:indexPath.row];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"HomeMenuCell" owner:self options:nil];
		cell = tmpCell;
		self.tmpCell = nil;
	}
	
	UILabel *rank = (UILabel *)[cell viewWithTag:1];
	rank.text = [NSString stringWithFormat:@"#%d", indexPath.row+1];
	rank.font = [UIFont fontWithName:@"AvantGarde" size:rank.font.pointSize];
	
	UILabel *name = (UILabel *)[cell viewWithTag:2];
	name.text = currentPlayer.alias;
	name.font = [UIFont fontWithName:@"AvantGarde" size:name.font.pointSize];
	
	UILabel *points = (UILabel *)[cell viewWithTag:3];
	points.text = [NSString stringWithFormat:@"%d", (int)currentScore.value];
	points.font = [UIFont fontWithName:@"AvantGarde" size:points.font.pointSize];
	if (currentPlayer.playerID == [GKLocalPlayer localPlayer].playerID) {
		points.textColor = [UIColor redColor];
		rank.textColor = [UIColor redColor];
		name.textColor = [UIColor redColor];
	} else {
		points.textColor = [UIColor whiteColor];
		rank.textColor = [UIColor whiteColor];
		name.textColor = [UIColor whiteColor];
	}
	
	return cell;
}

- (void)dealloc {
	[self.view removeObserver:self forKeyPath:@"frame"];
	[[GameCenterManager sharedGameCenterManager] setDelegate:(AppDelegate *)[UIApplication sharedApplication].delegate];
	[scores release];
	[players release];
	
    [resetHelpView release];
    [resetHelpButt release];
    
	[tableView release];
    [bgView release];
	[headerBar release];
	[titleBar release];
	
	[onePlayer release];
	[twoPlayer release];
	
	[labels release];
	[super dealloc];
}

@end
