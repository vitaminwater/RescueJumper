//
//  AppDelegate.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/28/12.
//  Copyright {EPITECH.} 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameCenterManager.h"
#import "Facebook.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, GameCenterManagerDelegate, FBSessionDelegate> {

	UIWindow			*window;
	RootViewController	*viewController;
    Facebook *facebook;
    void (^successHandler)(void);

}

@property(nonatomic, retain) UIWindow *window;
@property(nonatomic, readonly) UIViewController *viewController;
@property(nonatomic, readonly) Facebook *facebook;

- (void)showMenu:(UIViewController *)menuController player:(NSInteger)player;
- (void)removeMenu:(UIViewController *)menuController;
- (void)startFB:(void(^)(void))onSuccess;

@end
