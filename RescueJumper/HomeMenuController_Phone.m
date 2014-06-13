//
//  HomeMenuController_Phone.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 6/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HomeMenuController_Phone.h"

#import "cocos2d.h"
#import "AppDelegate.h"

@interface HomeMenuController_Phone ()

@end

@implementation HomeMenuController_Phone

- (IBAction)selectMusic:(id)sender {
	MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
	[self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[super mediaPicker:mediaPicker didPickMediaItems:mediaItemCollection];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[super mediaPickerDidCancel:mediaPicker];
    [self dismissModalViewControllerAnimated:YES];
}

@end
