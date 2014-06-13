//
//  PlayerData.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "PlayerData.h"

#import "ChainList.h"
#import "Bipede.h"

#import "Game.h"

#import "AnimatedDisplayObject.h"

#import "StatItemKeys.h"
#import "StatItem.h"
#import "StatItemMax.h"

@implementation PlayerData

@synthesize jumpBaseLevel;
@synthesize maxJumpDistance;

@synthesize score;
@synthesize statItems;

@synthesize currentClockGuysSaved;

@synthesize bipedes;
@synthesize activeBipedes;

- (id)initWithGame:(Game *)_game {
	
	if (self = [super init]) {
		jumpBaseLevel = 1;
		maxJumpDistance = 180;
		
		score = 0;
		
		currentClockGuysSaved = 0;
		
		game = _game;
		
        statItems = [[NSArray arrayWithObjects:
					[StatItem statItemWithName:NSLocalizedString(@"StatTime", @"") key:STAT_TIME],
                    [StatItem statItemWithName:NSLocalizedString(@"StatLevel", @"") key:STAT_LEVEL],
                    [StatItem statItemWithName:NSLocalizedString(@"StatConverted", @"") key:STAT_CONVERTED_HUMAN],
                    [StatItem statItemWithName:NSLocalizedString(@"StatSaved", @"") key:STAT_SAVED_HUMAN],
					[StatItem statItemWithName:NSLocalizedString(@"StatSavedOctave", @"") key:STAT_SAVED_OCTAVE],
					[StatItem statItemWithName:NSLocalizedString(@"StatNukedZombies", @"") key:STAT_NUKED_ZOMBIES],
					[StatItem statItemWithName:NSLocalizedString(@"StatEndHumans", @"") key:STAT_END_HUMAN],
					[StatItem statItemWithName:NSLocalizedString(@"StatHumanBonus", @"") key:STAT_BONUS_HUMAN],
					[StatItem statItemWithName:NSLocalizedString(@"StatCoins", @"") key:STAT_COINS],
					[StatItem statItemWithName:NSLocalizedString(@"StatFullShip", @"") key:STAT_SHIP_FULL],
					[StatItem statItemWithName:NSLocalizedString(@"StatTotalShips", @"") key:STAT_N_SHIP],
					[StatItem statItemWithName:NSLocalizedString(@"StatNiceCatch", @"") key:STAT_NICE_CATCH],
					[StatItem statItemWithName:NSLocalizedString(@"StatJumpBases", @"") key:STAT_JUMPBASE_CREATED],
					[StatItemMax statItemWithName:NSLocalizedString(@"StatMaxZombies", @"") key:STAT_MAX_ZOMBIES],
					[StatItemMax statItemWithName:NSLocalizedString(@"StatMaxHumans", @"") key:STAT_MAX_HUMANS],
                    [StatItem statItemWithName:NSLocalizedString(@"StatTotalJumps", @"") key:STAT_N_JUMPS],
                    [StatItem statItemWithName:NSLocalizedString(@"StatBrokenWalls", @"") key:STAT_N_BROKEN_WALL],
                    [StatItem statItemWithName:NSLocalizedString(@"StatBrokenPlateform", @"") key:STAT_N_BROKEN_PLATEFORME],
                    [StatItem statItemWithName:NSLocalizedString(@"StatBrokenShip", @"") key:STAT_N_BROKEN_SHIP],
					[StatItem statItemWithName:NSLocalizedString(@"StatFailedJumps", @"") key:STAT_N_MISSED_JUMPS],
					[StatItem statItemWithName:NSLocalizedString(@"StatMissedHumans", @"") key:STAT_MISSED_HUMAN],
					[StatItem statItemWithName:NSLocalizedString(@"StatMissedOctave", @"") key:STAT_MISSED_OCTAVE],
					[StatItem statItemWithName:NSLocalizedString(@"StatKilledHumans", @"") key:STAT_KILLED_HUMAN],
					[StatItem statItemWithName:NSLocalizedString(@"StatKilledOctave", @"") key:STAT_KILLED_OCTAVE],
					[StatItem statItemWithName:NSLocalizedString(@"StatInfected", @"") key:STAT_INFECTED], nil] retain];
        
		bipedes = [[ChainList alloc] initWithAddCallbacks:@selector(bipedeAdded:) removeCallBack:@selector(bipedeRemoved:) delegate:self];
		activeBipedes = [[ChainList alloc] initWithAddCallbacks:@selector(dummyCallBack:) removeCallBack:@selector(dummyCallBack:) delegate:self];
	}
	
	return self;
}

- (void)setJumpBaseLevel:(NSUInteger)_jumpBaseLevel {
	if (_jumpBaseLevel > 3)
		return;
	jumpBaseLevel = _jumpBaseLevel;
}

- (void)setBipedeActive:(Bipede *)bipede active:(BOOL)active {
	if (active) {
		__block BOOL add = YES;
		[activeBipedes iterateOrRemove:^BOOL(id entry) {
			if (entry == bipede) {
				add = NO;
				return YES;
			}
			return NO;
		} removeOnYES:NO exit:YES];
		if (add)
			[activeBipedes addEntry:bipede];
	} else {
		[activeBipedes iterateOrRemove:^BOOL(id entry) {
			return bipede == entry;
		} removeOnYES:YES exit:YES];
	}
}

- (void)bipedeAdded:(Bipede *)bipede {
	__block BOOL add = YES;
	[activeBipedes iterateOrRemove:^BOOL(id entry) {
		if (entry == bipede) {
			add = NO;
			return YES;
		}
		return NO;
	} removeOnYES:NO exit:YES];
	if (add)
		[activeBipedes addEntry:bipede];
}

- (void)bipedeRemoved:(Bipede *)bipede {
	[activeBipedes iterateOrRemove:^BOOL(id entry) {
		if (entry == bipede)
			return YES;
		return NO;
	} removeOnYES:YES exit:YES];
}

- (void)addStat:(NSUInteger)statType n:(CGFloat)n pts:(CGFloat)pts {
    StatItem *statItem = [statItems objectAtIndex:statType];
    [statItem addItem:n pts:pts];
}

- (void)removeStat:(NSUInteger)statType n:(CGFloat)n pts:(CGFloat)pts {
    StatItem *statItem = [statItems objectAtIndex:statType];
    [statItem removeItem:n pts:pts];
}

- (StatItem *)getStatItem:(NSUInteger)statType {
    return [statItems objectAtIndex:statType];
}

- (void)dummyCallBack:(Bipede *)bipede {}

- (void)dealloc {
	[bipedes release];
	[activeBipedes release];
    [statItems release];
	[super dealloc];
}

@end
