//
//  HelpCenter.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 3/30/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ccTypes.h"

#import "KSSingleton.h"

@protocol HelpHolder<NSObject>

- (CGPoint)helpPosition;

@end

@class ChainList;
@class Game;

@interface HelpCenter : NSObject {
	
	ChainList *alreadyShown;
	ChainList *helpLabels;
	
	Game *game;
}

@property(nonatomic, assign)ChainList *helpLabels;
@property(nonatomic, assign)Game *game;

KS_SINGLETON_INTERFACE(HelpCenter)

- (void)update:(ccTime)dt;
- (void)createHelper:(NSString *)frameName holder:(NSObject<HelpHolder> *)holder;
- (void)removeHelper:(NSObject<HelpHolder> *)holder;

@end
