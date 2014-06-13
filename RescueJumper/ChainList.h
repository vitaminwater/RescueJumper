//
//  ChainList.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _BaseChain {
	
    struct _BaseChain *prev;
	struct _BaseChain *next;
	id object;
	
} BaseChain;

//typedef void(^CallBackBlock)(id);

@interface ChainList : NSObject {
	
	BaseChain *entries;
    BaseChain *last;
	
	id delegate;
	SEL addCallBack;
	SEL removeCallBack;
	
	NSInteger count;
    
    BOOL retainObjs;
	
}

@property(nonatomic, assign)id delegate;
@property(nonatomic, readonly)NSInteger count;

- (id)initWithAddCallbacks:(SEL)_add removeCallBack:(SEL)_remove delegate:(id)_delegate;
- (id)initWithAddCallbacks:(SEL)_add removeCallBack:(SEL)_remove delegate:(id)_delegate retainObjs:(BOOL)_retainObjs;

- (void)addEntry:(id)object;
- (void)addEntries:(ChainList *)newEntries;
- (void)iterateOrRemove:(BOOL(^)(id entry))condition removeOnYES:(BOOL)remove exit:(BOOL)exit;
- (id)removeLastEntry;
- (id)lastInserted;

@end
