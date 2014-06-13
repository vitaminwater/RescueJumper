//
//  Actioner.h
//  RescueLander
//
//  Created by stant on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __ACTIONER_H
#define __ACTIONER_H

#import "cocos2d.h"

@class ChainList;

@protocol Action

-(BOOL)canTrigger;
-(NSObject<Action> *)trigger;
-(NSObject<Action> *)next;
-(void)setNext:(NSObject<Action> *)nextArg;
-(BOOL)blocker;
-(int)getPriority;
-(BOOL)update:(float)dt;
-(void)end:(BOOL)interrupted;

@end

@interface Actioner : NSObject {

	ChainList *actions;
	NSObject<Action> *currentAction;
	
}

@property(nonatomic,readonly)ChainList *actions;
@property(nonatomic,readonly)NSObject<Action> *currentAction;

-(void)addAction:(NSObject<Action> *)action;
-(void)removeAction:(NSObject<Action> *)action;
-(void)removeActionByName:(NSString *)name;
-(void)removeAllActions;
-(void)update:(float)dt;
-(void)setCurrentAction:(NSObject<Action> *)action interrupted:(BOOL)interrupted;
-(void)endCurrentAction:(BOOL)doNext interrupted:(BOOL)interrupted;
-(BOOL)blocker;
-(NSObject<Action> *)getActionFromName:(NSString *)name;

@end

#endif