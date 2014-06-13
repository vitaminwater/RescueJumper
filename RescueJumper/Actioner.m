//
//  Actioner.m
//  RescueLander
//
//  Created by stant on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Actioner.h"

#import "ChainList.h"

@implementation Actioner

@synthesize actions;
@synthesize currentAction;

-(id)init
{
	if ((self = [super init])) {
		actions = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
		currentAction = nil;
	}
	return self;
}

-(void)addAction:(NSObject<Action> *)action
{
	if (action == nil)
		return;
	[actions addEntry:action];
}

-(void)removeAction:(NSObject<Action> *)action
{
	if (action == nil)
		return;
	[actions iterateOrRemove:^BOOL(id entry) {
		return entry == action;
	} removeOnYES:YES exit:YES];
}

-(void)removeActionByName:(NSString *)name
{
	NSObject<Action> *action = [self getActionFromName:name];
	if (action != nil)
		[self removeAction:action];
}

-(void)removeAllActions {
	if (currentAction != nil) {
		[currentAction end:NO];
		[currentAction release];
		currentAction = nil;
	}
	[actions iterateOrRemove:^BOOL(id entry) {
		return YES;
	} removeOnYES:YES exit:NO];
}

-(void)update:(float)dt
{
	if (currentAction != nil && ![currentAction update:dt]) {
		[self endCurrentAction:YES interrupted:NO];
	}
	if ([self blocker])
		return;
	__block NSObject<Action> *newAction = currentAction;
	[actions iterateOrRemove:^BOOL(id entry) {
		NSObject<Action> *action = entry;
		if (currentAction != action && (newAction == nil || [newAction getPriority] < [action getPriority]) && [action canTrigger])
			newAction = action;
		return NO;
	} removeOnYES:NO exit:NO];
	if (newAction != currentAction) {
		[self setCurrentAction:newAction interrupted:YES];
	}
}

-(void)setCurrentAction:(NSObject<Action> *)action interrupted:(BOOL)interrupted {
	if (currentAction != nil) {
		[self endCurrentAction:NO interrupted:interrupted];
	}
	//NSLog(@"%@ started", NSStringFromClass([newAction class]));
	currentAction = [[action trigger] retain];
}

-(void)endCurrentAction:(BOOL)doNext interrupted:(BOOL)interrupted
{
	//NSLog(@"%@ stopped", NSStringFromClass([currentAction class]));
	[currentAction end:interrupted];
	NSObject<Action> *next;
	if (doNext && (next = [currentAction next]) != nil) {
		[currentAction release];
		currentAction = [[next trigger] retain];
	} else {
		[currentAction release];
		currentAction = nil;
	}
}

-(BOOL)blocker
{
	if (currentAction == nil)
		return NO;
	return [currentAction blocker];
}

-(NSObject<Action> *)getActionFromName:(NSString *)name
{
	__block NSObject<Action> *result = nil;
	[actions iterateOrRemove:^BOOL(id entry) {
		NSObject<Action> *action = entry;
		if (![NSStringFromClass([action class]) compare:name]) {
			result = action;
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
	return result;
}

- (void)dummy:(id)entry {}

-(void)dealloc
{
	if (currentAction != nil) {
		[currentAction release];
	}
	[actions release];
	[super dealloc];
}

@end
