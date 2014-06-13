//
//  EndLevelGameStateAction.m
//  RescueJumper
//
//  Created by Constantin on 12/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "GameStateActionLevelEnd.h"

#import "AppDelegate.h"

#import "LevelEndViewController.h"

#import "Actioner.h"

@implementation GameStateActionLevelEnd

- (id)initWithGame:(Game *)_game title:(NSString *)_title message:(NSString *)_message grade:(NSUInteger)_grade {
    
    if (self = [super initWithGame:_game]) {
        title = [_title retain];
        message = [_message retain];
        grade = _grade;
    }
    return self;
    
}

- (int)getPriority {
	return 10;
}

- (NSObject<Action> *)trigger {
    [game unscheduleAllSelectors];
    [[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
    levelEndViewController = [[LevelEndViewController alloc] initWithTitle:title message:message grade:grade];
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showMenu:levelEndViewController player:0];
    return [super trigger];
}

- (BOOL)update:(float)dt {
    return YES;
}

- (void)dealloc {
    [(AppDelegate *)[UIApplication sharedApplication].delegate removeMenu:levelEndViewController];
    [levelEndViewController release];
    [title release];
    [message release];
    [super dealloc];
}

@end
