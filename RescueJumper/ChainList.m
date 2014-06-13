//
//  ChainList.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ChainList.h"

@interface ChainList()

@property(nonatomic, assign)BaseChain *last;
@property(nonatomic, assign)BaseChain *entries;

@property(nonatomic, readonly)BOOL retainObjs;

@end

@implementation ChainList

@synthesize delegate;
@synthesize count;
@synthesize last;
@synthesize entries;

@synthesize retainObjs;

- (id)initWithAddCallbacks:(SEL)_add removeCallBack:(SEL)_remove delegate:(id)_delegate {
	if (self = [super init]) {
		count = 0;
		addCallBack = _add;
		removeCallBack = _remove;
		delegate = _delegate;
        
        entries = 0;
        
        retainObjs = YES;
	}
	return self;
}

- (id)initWithAddCallbacks:(SEL)_add removeCallBack:(SEL)_remove delegate:(id)_delegate retainObjs:(BOOL)_retainObjs {

    if (self = [self initWithAddCallbacks:_add removeCallBack:_remove delegate:_delegate]) {
        retainObjs = _retainObjs;
    }
    return self;
    
}

- (void)addEntry:(id)object {
	[delegate performSelector:addCallBack withObject:object];
	BaseChain *entry = malloc(sizeof(BaseChain));
	entry->object = object;
    if (retainObjs)
        [object retain];
    entry->prev = 0;
	entry->next = entries;
    if (entries)
        entries->prev = entry;
    else
        last = entry;
	entries = entry;
	count++;
}

- (void)addEntries:(ChainList *)newEntries {
    if (!newEntries || ![newEntries count] || newEntries.retainObjs != self.retainObjs)
        return;
    newEntries.last->next = entries;
    entries->prev = newEntries.last;
    entries = newEntries.entries;
    newEntries.entries = 0;
    newEntries.last = 0;
    count += [newEntries count];
}

- (void)iterateOrRemove:(BOOL(^)(id entry))condition removeOnYES:(BOOL)remove exit:(BOOL)exit {
	for (BaseChain *current = entries; current;) {
		if (condition(current->object)) {
			BaseChain *tmp = current->next;
			if (remove) {
				[delegate performSelector:removeCallBack withObject:current->object];
                if (retainObjs)
                    [current->object release];
                if (current == last)
                    last = current->prev;
				if (current->prev) {
					current->prev->next = current->next;
                    if (current->next)
                        current->next->prev = current->prev;
				} else {
					entries = current->next;
                    if (entries)
                        entries->prev = 0;
                }
				free(current);
				count--;
			}
			if (exit)
				return;
			current = tmp;
		} else {
			current = current->next;
		}
	}
}

- (id)removeLastEntry {
    if (!last)
        return nil;
    id object = last->object;
    BaseChain *tmp = last;
    last = last->prev;
    last->next = 0;
    
    free(tmp);
    [delegate performSelector:removeCallBack withObject:object];
    if (retainObjs)
        [object autorelease];
    count--;
    return object;
}

- (id)lastInserted {
    if (entries)
        return entries->object;
    return nil;
}

- (void)dealloc {
	[self iterateOrRemove:^BOOL(id entry) {
		return YES;
	} removeOnYES:YES exit:NO];
	[super dealloc];
}

@end
