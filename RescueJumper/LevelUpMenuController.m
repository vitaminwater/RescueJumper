//
//  LevelUpController.m
//  RescueJumper
//
//  Created by Constantin on 5/25/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelUpMenuController.h"

#import <QuartzCore/QuartzCore.h>

#import "SwitchButton.h"

#import "Display.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"
#import "GameStateActionLevelUp.h"
#import "StatItem.h"

#import "ShopItemMenuController.h"

@interface LevelUpMenuController ()
@end

@implementation LevelUpMenuController

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData player:(NSUInteger)_player delegate:(NSObject<LevelUpMenuControllerDelegate> *)_delegate levelHelpers:(NSArray *)_levelHelpers
{
    self = [super initWithNibName:@"LevelUpMenuController" bundle:nil];
    if (self) {
        game = _game;
        gameData = _gameData;
		player = _player;
		delegate = _delegate;
		
		levelHelpers = [_levelHelpers retain];
        shopItems = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([Display sharedDisplay].n == 1 && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	
    bgView.layer.cornerRadius = 10;
	
	bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textbg.png"]];
	titleBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textyell.png"]];
	for (UIView *headerBar in headerBars) headerBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textdanger.png"]];
    
    readyFor.text = NSLocalizedString(@"ReadyFor", @"");
    showTutorial.text = NSLocalizedString(@"ShowTutorial", @"");
    clockPicked.text = NSLocalizedString(@"ClockPicked", @"");
    
    shopTitleBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textblue.png"]];
    coinLabel.text = [NSString stringWithFormat:@"%d", (int)[[game.playerData[player] getStatItem:STAT_COINS] resultN]];

	levelTitle.text = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Level", @""), gameData.currentLevel];
	
	levelNumber.text = [NSString stringWithFormat:@"%@ %02d", NSLocalizedString(@"Level", @""), gameData.currentLevel];
	
	levelTime.text = [NSString stringWithFormat:@"%@ : %d\"", NSLocalizedString(@"TimeForLevel", @""), (NSInteger)gameData.timeForNext];
	if (!gameData.timeForNext) {
		levelTime.hidden = YES;
		timeIcon.hidden = YES;
		bgClockGuys.hidden = YES;
		blockGuiesProc = NO;
	} else {
		totalClockGuys = 0;
		blockGuiesProc = YES;
        goButton.enabled = NO;
		for (int i = 0; i < game.nPlayer; ++i) totalClockGuys+=game.playerData[i].currentClockGuysSaved;
		
		CGSize imageSize = CGSizeMake(50.0f, 50.0f);
		CGRect clockFrame = clockGuys.frame;
		
		NSMutableArray *yellowImgs = [NSMutableArray array];
		for (int i = 0; i < 36; ++i) [yellowImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"score_tempsj%d.png", i + 1]]];
		NSMutableArray *pinkImgs = [NSMutableArray array];
		for (int i = 0; i < 36; ++i) [pinkImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"score_tempsr%d.png", i + 1]]];
		
		for (int i = 0; i < totalClockGuys; ++i) {
			UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
			if ((i < game.playerData[player].currentClockGuysSaved) ^ (player == 1))
				clockImage.animationImages = yellowImgs;
			else
				clockImage.animationImages = pinkImgs;
			clockImage.animationDuration = 1.0f;
			clockImage.animationRepeatCount = 0;
			[clockImage startAnimating];
			clockImage.center = CGPointMake(clockFrame.size.width / 2,
											clockFrame.size.height / 2 + 10.0f);
			clockImage.contentMode = UIViewContentModeScaleAspectFit;
			//clockImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
			clockImage.alpha = 0;
			clockImage.hidden = YES;
			[clockGuys addSubview:clockImage];
			[clockImage release];
		}
        CGRect frame = bgClockGuys.frame;
        frame.origin = CGPointMake(0, 0);
        frame.size = scrollView.frame.size;
        bgClockGuys.frame = frame;
        [scrollView addSubview:bgClockGuys];
		time = -0.3;
	}
	
    if (gameData.currentLevel > 1) {
        [game.playerData[player] addStat:STAT_LEVEL n:1 pts:gameData.currentLevel * 1000];
		[game addScore:gameData.currentLevel * 1000 player:player];
    }
    
	NSInteger x = (!bgClockGuys.hidden ? bgClockGuys.frame.size.width : 0);
	for (NSString *pic in levelHelpers) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pic]];
		CGRect frame = imageView.frame;
		frame.origin.x = x;
		frame.size = scrollView.frame.size;
		imageView.frame = frame;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[scrollView addSubview:imageView];

		x += scrollView.frame.size.width;
	}
    
    if (gameData.currentLevel > 6) {
        /*
         NSString *pic;
         NSString *descr;
         NSNumber *price;
         NSString *name;
         */
        shopItemDescr itemDescrs[] = {(shopItemDescr){@"item_missile.png", NSLocalizedString(@"MissileLauncherDescription", @""), 30, @"Super Auto Gun", ^{
            currentPage = -1;
            if ([game addLeft:1 buttonType:TOURELLE_BUTTON player:player]) {
                [game.playerData[player] removeStat:STAT_COINS n:30 pts:30];
                [self updateShops];
                coinLabel.text = [NSString stringWithFormat:@"%d", (NSUInteger)[[game.playerData[player] getStatItem:STAT_COINS] resultN]];
            }
            return;
        }, [[game.playerData[player] getStatItem:STAT_COINS] resultN] >= 30, TOURELLE_BUTTON, [game getLeft:TOURELLE_BUTTON player:player]},
			(shopItemDescr){@"item_navette.png", NSLocalizedString(@"ShipItemDescription", @""), 75, @"Extra Ship", ^{
            currentPage = -1;
            if ([game addLeft:1 buttonType:SHIP_BUTTON player:player]) {
                [game.playerData[player] removeStat:STAT_COINS n:75 pts:75];
                [self updateShops];
                coinLabel.text = [NSString stringWithFormat:@"%d", (NSUInteger)[[game.playerData[player] getStatItem:STAT_COINS] resultN]];
            }
            return;
        }, [[game.playerData[player] getStatItem:STAT_COINS] resultN] >= 75, SHIP_BUTTON, [game getLeft:SHIP_BUTTON player:player]}};
        NSUInteger nShopItems = sizeof(itemDescrs) / sizeof(shopItemDescr);
        
        for (int i = 0; i < nShopItems; ++i) {
            ShopItemMenuController *shopItemController = [[ShopItemMenuController alloc] initWithShopItemDescr:itemDescrs[i]];
            CGRect frame = shopItemController.view.frame;
            frame.origin.x = x;
            frame.size = scrollView.frame.size;
            shopItemController.view.frame = frame;
            
            [scrollView addSubview:shopItemController.view];
            [shopItems addObject:shopItemController];
            [shopItemController release];
            
            x += scrollView.frame.size.width;
        }
    }
	
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [scrollView.subviews count], scrollView.frame.size.height);
	pageControl.numberOfPages = [scrollView.subviews count];
    
    shopHeaderView.alpha = 0;
    shopHeaderView.hidden = YES;
    
	for (UILabel *label in labels) {
		label.font = [UIFont fontWithName:@"AvantGarde" size:label.font.pointSize];
	}
	
}

- (void)updateShops {
    for (ShopItemMenuController *shopItemController in shopItems) {
        shopItemController.buyButt.enabled = [[game.playerData[player] getStatItem:STAT_COINS] resultN] >= shopItemController.itemDescr.price;
		[shopItemController setLeft:[game getLeft:shopItemController.itemDescr.itemType player:player]];
    }
}

- (void)update:(ccTime)dt {
	if (blockGuiesProc) {
		if (time > 0.0f && time < 2.0f) {
            NSUInteger currentClockGuyIndex = time * (CGFloat)totalClockGuys / 2;
			UIView *clockGuy = ((UIView *)[clockGuys.subviews objectAtIndex:currentClockGuyIndex]);
			if (clockGuy.hidden) {
				clockGuy.hidden = NO;
				[UIView animateWithDuration:0.2f animations:^{
					clockGuy.alpha = 1.0f;
					for (UIView *v in clockGuys.subviews) {
						if (v.hidden)
							continue;
						v.frame = [self clockPosition:[clockGuys.subviews indexOfObject:v] total:currentClockGuyIndex + 1];
					}
				}];
			}
			clockGuysLabel.text = [NSString stringWithFormat:@"= %d'%02d\"", (NSUInteger)((CGFloat)gameData.timeForNext * time / 2) / 60, (NSUInteger)((CGFloat)gameData.timeForNext * time / 2) % 60];
		} else if (time > 4.0f) {
            goButton.enabled = YES;
			blockGuiesProc = NO;
			if (!scrollView.contentOffset.x && [scrollView.subviews count] - 1) {
				[UIView animateWithDuration:0.2f animations:^{
					scrollView.contentOffset = CGPointMake(bgClockGuys.frame.size.width, 0);
					pageControl.currentPage = 1;
				}];
			}
		}
		if (time > 2.0f)
			clockGuysLabel.text = [NSString stringWithFormat:@"= %d'%02d\"", (NSUInteger)gameData.timeForNext / 60, ((NSUInteger)gameData.timeForNext) % 60];
	} else if (currentPage >= 0) {
		currentPage += dt / 2.0f;
		NSInteger newPage = ((int)currentPage % ([scrollView.subviews count] - (gameData.timeForNext ? 1 : 0))) + (gameData.timeForNext ? 1 : 0);
		if (newPage != pageControl.currentPage) {
			[UIView animateWithDuration:0.2f animations:^{
				CGPoint newOffset = CGPointMake(scrollView.frame.size.width * newPage, 0);
				scrollView.contentOffset = newOffset;
			}];
			pageControl.currentPage = newPage;
            [self updateShopHeader];
		}
	}
	time += dt;
}

- (CGRect)clockPosition:(NSUInteger)index total:(NSUInteger)total {
    NSUInteger nLine = ceilf((CGFloat)total / 5.0f);
    NSUInteger nPerLine = ceilf((CGFloat)total / (CGFloat)nLine);
	CGSize size = CGSizeMake(clockGuys.frame.size.width / nPerLine > 50 ? 50 : clockGuys.frame.size.width / nPerLine, clockGuys.frame.size.height / nLine);
    CGPoint offset = CGPointMake(clockGuys.frame.size.width / 2 - (CGFloat)nPerLine * size.width / 2, clockGuys.frame.size.height / 2 - (CGFloat)nLine * size.height / 2);
    return CGRectMake(offset.x + (CGFloat)(index % nPerLine) * size.width, offset.y + floorf((CGFloat)index / nPerLine) * size.height, size.width, size.height);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"frame"]) {
		CGRect frame = self.view.frame;
		frame.size = CGSizeMake(frame.size.width * 0.4f, frame.size.height * 0.4f);
		frame.origin = CGPointMake(self.view.frame.size.width / 2 - frame.size.width / 2, self.view.frame.size.height / 2 - frame.size.height / 2);
		bgView.frame = frame;
	}
}

- (void)viewDidLayoutSubviews {
	int x = 0;
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [scrollView.subviews count], scrollView.frame.size.height);
	for (UIView *page in scrollView.subviews) {
		CGRect pageFrame = page.frame;
		pageFrame.origin.x = x;
		pageFrame.size = scrollView.frame.size;
		page.frame = pageFrame;
		x += pageFrame.size.width;
	}
}

- (IBAction)disableAutoScroll:(id)sender {
    currentPage = -1;
    goButton.enabled = YES;
    [scrollView removeGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
	pageControl.currentPage = scrollView.contentOffset.x / _scrollView.frame.size.width;
    [self updateShopHeader];
}

- (void)updateShopHeader {
    for (ShopItemMenuController *shopItem in shopItems) {
        if (shopItem.view.frame.origin.x / scrollView.frame.size.width == pageControl.currentPage) {
            [UIView animateWithDuration:0.2 animations:^{
                shopHeaderView.alpha = 1.0f;
                shopHeaderView.hidden = NO;
            }];
            return;
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        shopHeaderView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        shopHeaderView.hidden = YES;
    }];
}

- (IBAction)goPressed:(id)sender {
	[delegate startNextLevel:self];
    [shopItems release];
    shopItems = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

- (void)dealloc {
    if ([Display sharedDisplay].n == 1 && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        [self.view removeObserver:self forKeyPath:@"frame"];
	[bgView release];
	[titleBar release];
    
    [readyFor release];
    [showTutorial release];
    [clockPicked release];
	
	[levelTitle release];
	[levelNumber release];
	[levelTime release];
    [timeIcon release];
    
    [shopHeaderView release];
    [coinLabel release];
    [shopTitleBar release];
	
	[scrollView release];
	[pageControl release];
    
    [goButton release];
    
	[labels release];
	[headerBars release];
	
	[bgClockGuys release];
	[clockGuys release];
	[clockGuysLabel release];
    
    [levelHelpers release];
    [shopItems release];
	[super dealloc];
}

@end
