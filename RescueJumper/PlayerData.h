//
//  PlayerData.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChainList;
@class Bipede;
@class Game;
@class StatItem;

@interface PlayerData : NSObject {
	
	Game *game;
	
	NSUInteger jumpBaseLevel;
	CGFloat maxJumpDistance;
	
	CGFloat score;
    NSArray *statItems;
	
	NSUInteger currentClockGuysSaved;
	
	ChainList *bipedes;
	ChainList *activeBipedes;
	
}

@property(nonatomic, assign)NSUInteger jumpBaseLevel;
@property(nonatomic, assign)CGFloat maxJumpDistance;

@property(nonatomic, assign)CGFloat score;
@property(nonatomic, readonly)NSArray *statItems;

@property(nonatomic, assign)NSUInteger currentClockGuysSaved;

@property(nonatomic, readonly)ChainList *bipedes;
@property(nonatomic, readonly)ChainList *activeBipedes;

- (id)initWithGame:(Game *)_game;
- (void)setBipedeActive:(Bipede *)bipede active:(BOOL)active;
- (void)addStat:(NSUInteger)statType n:(CGFloat)n pts:(CGFloat)pts;
- (void)removeStat:(NSUInteger)statType n:(CGFloat)n pts:(CGFloat)pts;
- (StatItem *)getStatItem:(NSUInteger)statType;

@end
