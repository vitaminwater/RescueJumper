//
//  AppDelegate.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/28/12.
//  Copyright {EPITECH.} 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "Display.h"
#import "HomeMenu.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize facebook;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
/*#if GAME_AUTOROTATION == kGameAutorotationUIViewController

	CC_ENABLE_DEFAULT_GL_STATES();
	CCDirector *director = [CCDirector sharedDirector];
	CGSize size = [director winSize];
	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	sprite.position = ccp(size.width/2, size.height/2);
	sprite.rotation = -90;
	[sprite visit];
	[[director openGLView] swapBuffers];
	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController*/
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	//[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
	//[TestFlight takeOff:@"d6a2aacdf47b88cb357ccdf77d541a32_NDQ2MTQyMDExLTEyLTAxIDA3OjE1OjA5Ljg5MDQ2Ng"];
	//[TestFlight setOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"disableInAppUpdates"]];
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	[director setProjection:kCCDirectorProjection2D];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	[glView setMultipleTouchEnabled:YES];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	//[director enableRetinaDisplay:NO];
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
#endif
	
	[director setAnimationInterval:1.0f/60.0f];
	//[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime

	// Removes the startup flicker
	[self removeStartupFlicker];
	
	srand(time(NULL));
	
	if ([GameCenterManager isGameCenterAvailable]) {
		
        [[GameCenterManager sharedGameCenterManager] setDelegate:self];
        [[GameCenterManager sharedGameCenterManager] authenticateLocalUser];
		
    }
	
	[[CCDirector sharedDirector] runWithScene:[HomeMenu scene]];
}

- (void)startFB:(void(^)(void))onSuccess {
    successHandler = [onSuccess copy];
    if (facebook) {
        successHandler();
        [successHandler release];
        successHandler = nil;
        return;
    }
    facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:nil];
        return;
    }
    successHandler();
    [successHandler release];
    successHandler = nil;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    successHandler();
    [successHandler release];
    successHandler = nil;
}

- (void)fbSessionInvalidated {
    
}

- (void)fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)showMenu:(UIViewController *)menuController player:(NSInteger)player {
    CGAffineTransform landscapeTransform = CGAffineTransformIdentity;
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    menuController.view.layer.anchorPoint = CGPointMake(0, 0);

	if (player == -1 || [Display sharedDisplay].n == 1) {
		CGSize applicationSize = [[UIScreen mainScreen] bounds].size;
        frame.size = CGSizeMake(applicationSize.height, applicationSize.width);
        landscapeTransform = CGAffineTransformMakeTranslation(0, frame.size.width);
        landscapeTransform = CGAffineTransformRotate(landscapeTransform, -M_PI / 2.0f);
	} else {
		frame.size = [Display sharedDisplay].screenSize;
        landscapeTransform = CGAffineTransformMakeTranslation(player <= 0 ? 0 : frame.size.width, frame.size.height);
        landscapeTransform = CGAffineTransformRotate(landscapeTransform, player <= 0 ? 0 : M_PI);
    }
    
    menuController.view.frame = frame;
    
    [menuController.view setTransform:landscapeTransform];

	[self.viewController.view addSubview:menuController.view];
    
	menuController.view.alpha = 0.0;
	[UIView animateWithDuration:0.4 animations:^{
		menuController.view.alpha = 1.0;
	}];
}

- (void)removeMenu:(UIViewController *)menuController {
	[UIView animateWithDuration:0.4 animations:^{
		menuController.view.alpha = 0.0;
	} completion:^(BOOL finished) {
		[menuController.view removeFromSuperview];
	}];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
