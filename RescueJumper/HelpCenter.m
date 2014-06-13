//
//  HelpCenter.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "HelpCenter.h"

#import "Game.h"

#import "ChainList.h"

#import "HelpLabel.h"

#import "Display.h"
#import "StaticDisplayObject.h"

@implementation HelpCenter

@synthesize helpLabels;
@synthesize game;

KS_SINGLETON_IMPLEMENTATION(HelpCenter)

- (id)init {

	if (self = [super init]) {
		alreadyShown = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:)
												removeCallBack:@selector(dummyHandler:)
													  delegate:self];
		helpLabels = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:)
											  removeCallBack:@selector(dummyHandler:)
													delegate:self];
	}
	return self;

}

- (void)update:(ccTime)dt {
	[helpLabels iterateOrRemove:^BOOL(id entry) {
		HelpLabel *helpLabel = entry;
		[helpLabel update:dt];
		return helpLabel.sprite.position.x <= -[Display sharedDisplay].scrollX;
	} removeOnYES:YES exit:NO];
}

- (void)createHelper:(NSString *)frameName holder:(NSObject<HelpHolder> *)holder {
	__block BOOL notIn = YES;
	[alreadyShown iterateOrRemove:^BOOL(id entry) {
		NSString *tmp = entry;
		if (![tmp compare:frameName]) {
			notIn = NO;
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
	if (!notIn)
		return;
	HelpLabel *helpLabel = [[HelpLabel alloc] initWithSpriteFrameName:frameName
															   holder:holder];
	[helpLabels addEntry:[helpLabel autorelease]];
	[alreadyShown addEntry:frameName];
}

- (void)removeHelper:(NSObject<HelpHolder> *)holder {
	[helpLabels iterateOrRemove:^BOOL(id entry) {
		HelpLabel *label = entry;
		if (label.holder == holder) {
			label.holder = nil;
			[label hide];
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
}

- (void)dummyHandler:(id)entry {}

@end
