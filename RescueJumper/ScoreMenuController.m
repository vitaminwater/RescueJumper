//
//  ScoreMenuController.m
//  RescueJumper
//
//  Created by Constantin on 5/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ScoreMenuController.h"

#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>

#import "SimpleAudioEngine.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"
#import "Scores.h"
#import "StatItem.h"

#import "SendScore.h"

#import "GameStateActionEnd.h"

#import "AppDelegate.h"

#import "Display.h"


typedef struct s_mood {
	
	NSString *sentence;
	NSUInteger points;
	
} mood;

@implementation ScoreMenuController

@synthesize tmpCell;
@synthesize player;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player gameStateActionEnd:(GameStateActionEnd *)_gameStateActionEnd
{
    self = [super initWithNibName:@"ScoreMenuController" bundle:nil];
    if (self) {
        
		self.player = _player;
		game = _game;
        gameData = _gameData;
		gameStateActionEnd = _gameStateActionEnd;
        
        [game.playerData[player] addStat:STAT_TIME n:gameData.totalTime pts:10 * gameData.totalTime];
        for (StatItem *statItem in game.playerData[player].statItems) {
            totalScore += [statItem resultPts];
        }
		
        if (game.nPlayer == 1) {
            [[GameCenterManager sharedGameCenterManager] reportScore:(int)totalScore forCategory:SCORE_LEADERBOARD];
			[SendScore sendScore:game.playerData[player].statItems];
		}
        
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
		[numberFormatter setGroupingSeparator:@" "];
		[numberFormatter setPositiveFormat:@"000,000"];
		[numberFormatter setNegativeFormat:@"-000,000"];
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
	bgView.layer.cornerRadius = 10;
	
	bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textbg.png"]];
	scoreView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textbg.png"]];
	headerBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textdanger.png"]];
	titleBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textyell.png"]];
    
    totalView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_texttotal.png"]];
	
    for (UILabel *label in labels) {
		label.font = [UIFont fontWithName:@"AvantGarde" size:label.font.pointSize];
	}
    scoreLabel.font = [UIFont fontWithName:@"Liquid Crystal" size:scoreLabel.font.pointSize];

    
	retryButt.enabled = NO;
    
    if (game.nPlayer > 1) {
        for (UIButton *butt in shareButts) {
            butt.hidden = YES;
        }
    }
    
	mood moods[] = {
		(mood){NSLocalizedString(@"SurvivalEnd1", @""), 10000},
		(mood){NSLocalizedString(@"SurvivalEnd2", @""), 20000},
		(mood){NSLocalizedString(@"SurvivalEnd3", @""), 50000},
		(mood){NSLocalizedString(@"SurvivalEnd4", @""), 70000},
		(mood){NSLocalizedString(@"SurvivalEnd5", @""), 100000},
		(mood){NSLocalizedString(@"SurvivalEnd6", @""), 150000},
		(mood){NSLocalizedString(@"SurvivalEnd7", @""), 200000},
		(mood){NSLocalizedString(@"SurvivalEnd8", @""), 250000},
		(mood){NSLocalizedString(@"SurvivalEnd9", @""), 300000},
		(mood){NSLocalizedString(@"SurvivalEnd10", @""), 350000},
		(mood){NSLocalizedString(@"SurvivalEnd11", @""), 400000},
		(mood){NSLocalizedString(@"SurvivalEnd12", @""), 450000},
		(mood){NSLocalizedString(@"SurvivalEnd13", @""), 500000},
		(mood){NSLocalizedString(@"SurvivalEnd14", @""), 550000},
		(mood){NSLocalizedString(@"SurvivalEnd15", @""), 600000},
        (mood){NSLocalizedString(@"SurvivalEnd16", @""), 1000000}};
	
	for (int i = 0; i < sizeof(moods) / sizeof(mood); ++i) {
		if (i + 1 >= sizeof(moods) / sizeof(mood) || moods[i].points > totalScore) {
			moodLabel.text = moods[i].sentence;
			break;
		}
	}
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"scoreSound.wav"];
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([Display sharedDisplay].n == 1 && [keyPath isEqualToString:@"frame"] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGRect frame = self.view.frame;
		frame.size = CGSizeMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
		frame.origin = CGPointMake(self.view.frame.size.width / 2 - frame.size.width / 2, self.view.frame.size.height / 2 - frame.size.height / 2);
		bgView.frame = frame;
	}
}

- (void)update:(ccTime)dt {
    if (totalScoreDisplay == totalScore)
        return;
    totalScoreDisplay += totalScore * dt / 2.5;
    if ((totalScore < 0 && totalScoreDisplay < totalScore) || (totalScore > 0 && totalScoreDisplay > totalScore)) {
        totalScoreDisplay = totalScore;
		moodLabel.hidden = NO;
        retryButt.enabled = YES;
    }
    
	totalLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:(int)totalScoreDisplay]];
	scoreLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:(int)totalScoreDisplay]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [game.playerData[player].statItems count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];

    StatItem *item = [game.playerData[player] getStatItem:indexPath.row];

    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"ScoreMenuCell" owner:self options:nil];
		cell = tmpCell;
		self.tmpCell = nil;
    }

    UILabel *name = (UILabel *)[cell viewWithTag:1];
    name.text = item.name;
	name.font = [UIFont fontWithName:@"AvantGarde" size:name.font.pointSize];

    UILabel *nItems = (UILabel *)[cell viewWithTag:2];
	if (indexPath.row == STAT_TIME)
		nItems.text = [NSString stringWithFormat:@"%d'%02d\"", (NSUInteger)[item resultN] / 60, ((NSUInteger)[item resultN]) % 60];
	else
		nItems.text = [NSString stringWithFormat:@"%d", (NSUInteger)[item resultN]];
    nItems.font = [UIFont fontWithName:@"AvantGarde" size:nItems.font.pointSize];

    UILabel *total = (UILabel *)[cell viewWithTag:3];
    total.text = [NSString stringWithFormat:@"%d", (int)[item resultPts]];
	if ([item resultPts] >= 0)
		total.textColor = [UIColor greenColor];
	else
		total.textColor = [UIColor redColor];
	total.font = [UIFont fontWithName:@"AvantGarde" size:total.font.pointSize];

    return cell;
}

- (IBAction)retry:(id)sender {
	[gameStateActionEnd scoreMenuExited:self];
}

- (IBAction)google:(id)sender {
	//static NSString * const kClientId = @"YOUR_CLIENT_ID";
    //GooglePlusShare *googlePlus = [[GooglePlusShare alloc] initWithClientID:kClientId];
	
	//[TestFlight passCheckpoint:@"Share Google+ clicked"];
}

- (IBAction)facebook:(id)sender {
	[((AppDelegate *)[UIApplication sharedApplication].delegate) startFB:^{
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"412451102124232", @"app_id",
                                       @"http://www.rescuejumper.com/", @"link",
                                       @"http://www.rescuejumper.com/icon.jpg", @"picture",
                                       @"RescueJumper", @"name",
                                       [NSString stringWithFormat:NSLocalizedString(@"FBShareTitle", @""), totalLabel.text, ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone")], @"caption",
                                       [NSString stringWithFormat:NSLocalizedString(@"FBShareBody", @""), (int)[[game.playerData[player] getStatItem:STAT_SAVED_HUMAN] resultN], (int)[[game.playerData[player] getStatItem:STAT_KILLED_HUMAN] resultN], (int)[[game.playerData[player] getStatItem:STAT_SHIP_FULL] resultN]], @"description",
                                       nil];
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate).facebook dialog:@"feed"
               andParams:params
             andDelegate:self];
    }];
	//[TestFlight passCheckpoint:@"Share Facebook clicked"];
}

- (IBAction)twitter:(id)sender {
	TWTweetComposeViewController *twitterViewController = [[TWTweetComposeViewController alloc] init];
    [twitterViewController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"TwitterShare", @""), (int)[[game.playerData[player] getStatItem:STAT_SAVED_HUMAN] resultN], (int)[[game.playerData[player] getStatItem:STAT_KILLED_HUMAN] resultN], (int)[[game.playerData[player] getStatItem:STAT_SHIP_FULL] resultN], totalLabel.text]];
    [twitterViewController addImage:[UIImage imageNamed:@"http://www.rescuejumper.com/icon.jpg"]];
    
    [self presentViewController:twitterViewController animated:YES completion:nil];
    
    twitterViewController.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        if(res == TWTweetComposeViewControllerResultDone) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The Tweet was posted successfully." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];
            
        }
        if(res == TWTweetComposeViewControllerResultCancelled) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];
            
        }
        [self dismissModalViewControllerAnimated:YES];
    };
	//[TestFlight passCheckpoint:@"Share Twitter clicked"];
}

- (IBAction)gameCenter:(id)sender {
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.category = SCORE_LEADERBOARD;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
		[self presentModalViewController:[leaderboardController autorelease] animated:YES];
    }
}

- (IBAction)showStats:(id)sender {
	[UIView animateWithDuration:0.25 animations:^{
		scoreView.alpha = 0;
	} completion:^(BOOL finished) {
		scoreView.hidden = YES;
	}];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[self.view removeObserver:self forKeyPath:@"frame"];
	[numberFormatter release];
    
    [bgView release];
	[headerBar release];
	[titleBar release];
    
	[totalView release];
	[totalLabel release];
    
	[tableView release];

 	[labels release];
    
    [retryButt release];
    
    [shareButts release];
    
    [scoreView release];
    [scoreLabel release];
    [moodLabel release];
	[super dealloc];
}

@end
