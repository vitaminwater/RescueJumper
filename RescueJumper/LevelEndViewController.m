//
//  LevelEndViewController.m
//  RescueJumper
//
//  Created by Constantin on 12/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "LevelEndViewController.h"

#import "cocos2d.h"

#import "Display.h"

#import "LevelSelectorMenu.h"

@interface LevelEndViewController ()

@end

@implementation LevelEndViewController

- (id)initWithTitle:(NSString *)_titleMess message:(NSString *)_message grade:(NSUInteger)_grade
{
    self = [super initWithNibName:@"LevelEndViewController" bundle:nil];
    if (self) {
        titleMess = [_titleMess retain];
        message = [_message retain];
        grade = _grade;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
	bgView.layer.cornerRadius = 10;
    
    skyView.layer.cornerRadius = 10;
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        skyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"endlevelbg-ipad.png"]];
    else
        skyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"endlevelbg-iphone.png"]];
#else
    skyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"endlevelbg-iphone.png"]];
#endif
	
	bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textbg.png"]];
	headerBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textdanger.png"]];
	titleBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_textyell.png"]];
    
    titleLabel.font = [UIFont fontWithName:@"BurghleyBold" size:titleLabel.font.pointSize];
    titleLabel.text = titleMess;
    descrLabel.font = [UIFont fontWithName:@"BurghleyBold" size:descrLabel.font.pointSize];
    descrLabel.text = message;
    backButt.titleLabel.font = [UIFont fontWithName:@"Impact" size:backButt.titleLabel.font.pointSize];
    [backButt setTitle:NSLocalizedString(@"BackToMenu", @"") forState:UIControlStateNormal];
    UIImage *starImage;
#ifdef UI_USER_INTERFACE_IDIOM
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        starImage = [UIImage imageNamed:@"endlevelstat1-ipad.png"];
    else
        starImage = [UIImage imageNamed:@"endlevelstat1-iphone.png"];
#else
    starImage = [UIImage imageNamed:@"endlevelstat1-iphone.png"];
#endif
    for (int i = 0; i < grade; ++i) {
        ((UIImageView *)[stars objectAtIndex:i]).image = starImage;
    }
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"frame"] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGRect frame = self.view.frame;
		frame.size = CGSizeMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
		frame.origin = CGPointMake(self.view.frame.size.width / 2 - frame.size.width / 2, self.view.frame.size.height / 2 - frame.size.height / 2);
		bgView.frame = frame;
	}
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)endButtClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[LevelSelectorMenu scene]]];
}

- (void)dealloc {
    //[self.view removeObserver:self forKeyPath:@"frame"];
    [bgView release];
	[headerBar release];
	[titleBar release];
    
    [skyView release];
    [titleLabel release];
    [descrLabel release];
    [backButt release];
    [stars release];
    
    [titleMess release];
    [message release];
    [super dealloc];
}

@end
