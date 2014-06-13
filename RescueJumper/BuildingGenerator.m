//
//  BuildingElement.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "BuildingGenerator.h"

#import "cocos2d.h"
#import "BuildingPlateforme.h"

#import "Display.h"
#import "DisplayObject.h"

#import "Game.h"
#import "PlayerData.h"
#import "SurvivalGameData.h"

#import "LevelGenerator.h"
#import "BipedeGenerator.h"

#import "BlackHoleGenerator.h"
#import "GreenHoleGenerator.h"
#import "CollidObjectGenerator.h"

@implementation BuildingGenerator

@synthesize bipedeGenerator;

- (id)initWithGame:(Game *)_game gameData:(SurvivalGameData *)_gameData {
	
	if (self = [super initWithGame:_game gameData:_gameData]) {
		timeToNext = 5;
        firstDelay = 4;
		bipedeGenerator = [[BipedeGenerator alloc] initWithGame:game gameData:_gameData];
	}
	return self;
	
}

- (void)update:(ccTime)dt {
    if (firstDelay > 0) {
        firstDelay -= dt;
        return;
    }
	[bipedeGenerator update:dt];

    [super update:dt];
}

- (BOOL)canTrigger {
    BuildingPlateforme *last = [generatedElements lastInserted];
    CGRect collidRect = [last collidRect];
    CGFloat rightScreenLimit = -[Display sharedDisplay].scrollX + [Display sharedDisplay].size.width - 75.0f;
    if (last && collidRect.origin.x + collidRect.size.width > rightScreenLimit)
        return NO;
    return ([super canTrigger] || bipedeGenerator.nPendingBipedes);
}

- (void)execute {
	ChainList *buildings = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
    NSUInteger nBuildings = game.nPlayer;
    if (gameData.currentLevel >= 3 && (!(rand() % 3) || gameData.currentLevel > 7))
        nBuildings++;
    
    for (int i = 0; i < nBuildings; ++i) {
        
        BuildingPlateforme *building;
        
        BOOL createBuilding = NO;
        if (nBuildings == 1)
            createBuilding = (rand() % 2);
        else
            createBuilding = !i;
        if (!createBuilding) {
            building = [[BuildingPlateforme alloc] initWithSprite:@"plateform.png" game:game isSpriteFrame:YES];
            building.sprite.position = ccp([Display sharedDisplay].size.width + building.size.width / 2 - [Display sharedDisplay].scrollX + rand() % 100 + i * 60.0f,
                                           [Display sharedDisplay].size.height - 100 - (rand() % (int)([Display sharedDisplay].size.height * 0.6)));
            building.isCabled = YES;
        } else {
            building = [[BuildingPlateforme alloc] initWithSprite:[NSString stringWithFormat:@"building%d.png", rand() % 3] game:game isSpriteFrame:NO];
            building.sprite.position = ccp([Display sharedDisplay].size.width + building.size.width / 2 - [Display sharedDisplay].scrollX,
                                           building.size.height);
        }
        
        [levelGenerator.elements iterateOrRemove:^BOOL(id entry) {
            LevelElementGenerator *levelElement = entry;
            if (!([levelElement isKindOfClass:[CollidObjectGenerator class]] || [levelElement isKindOfClass:[BlackHoleGenerator class]] || [levelElement isKindOfClass:[GreenHoleGenerator class]]))
                return NO;
            CGRect elementRect = levelElement.lastRect;
            if (CGRectIntersectsRect(elementRect, [building collidRect])) {
                CGPoint pos = building.sprite.position;
                pos.x = elementRect.origin.x + elementRect.size.width;
                building.sprite.position = pos;
                return YES;
            }
            return NO;
        } removeOnYES:NO exit:YES];
        [building activate];
        
        [generatedElements addEntry:building];
        [game.jumpBases addEntry:building];
        [buildings addEntry:building];
		[[NSNotificationCenter defaultCenter] postNotificationName:BUILDING_ADDED object:building];
        [building release];
    }
	[bipedeGenerator generateBipedes:buildings];
    [buildings release];
	[super execute];
}

- (ccTime)getTimeToNext {
	return (rand() % 12) + 10;
}

- (CGPoint)helpPosition {
	CGRect lastRect = [self lastRect];
	return ccp(lastRect.origin.x + lastRect.size.width / 2, lastRect.origin.y + lastRect.size.height + 100);
}

- (void)dummy:(id)entry {}

- (void)dealloc {
	[bipedeGenerator release];
	[super dealloc];
}

@end
