//
//  HomeMenuController_Pad.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 6/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HomeMenuController_Pad.h"

#import "cocos2d.h"
#import "AppDelegate.h"

@interface HomeMenuController_Pad ()

@end

@implementation HomeMenuController_Pad

- (IBAction)selectMusic:(id)sender {
	MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
	popoverController = [[UIPopoverController alloc] initWithContentViewController:mediaPicker];
    mediaPicker.delegate = self;
    [mediaPicker release];
	[popoverController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[super mediaPicker:mediaPicker didPickMediaItems:mediaItemCollection];
	[popoverController dismissPopoverAnimated:YES];
	[popoverController release];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[super mediaPickerDidCancel:mediaPicker];
	[popoverController dismissPopoverAnimated:YES];
	[popoverController release];
}

@end
