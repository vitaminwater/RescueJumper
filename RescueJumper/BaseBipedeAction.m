//
//  BasePNJAction.m
//  RescueLander
//
//  Created by stant on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseBipedeAction.h"

@implementation BaseBipedeAction

-(id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game {
	if ((self = [super init])) {
		game = _game;
		bipede = bipedeArg;
		next = nil;
	}
	return self;
}

-(void)onTurn {}

-(BOOL)canTrigger{return YES;}
-(NSObject<Action> *)trigger{return self;}
-(NSObject<Action> *)next{return next;}
-(void)setNext:(NSObject<Action> *)nextArg{next = nextArg;}
-(BOOL)blocker{return NO;}
-(int)getPriority{return 0;}
-(BOOL)update:(float)dt{return NO;}
-(void)end:(BOOL)interrupted{}

-(void)dealloc
{
	if (next != nil)
		[next release];
	[super dealloc];
}

@end
