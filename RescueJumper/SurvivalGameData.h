//
//  SurvivalGameData.h
//  RescueJumper
//
//  Created by Constantin on 10/22/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

@interface SurvivalGameData : NSObject {
    
    ccTime totalTime;
	ccTime timeLeft;
    ccTime currentLevelTotalTime;
	ccTime timeForNext;
	NSUInteger currentLevel;
    
    CGFloat shipProgress;
    
}

@property(nonatomic, assign)ccTime totalTime;
@property(nonatomic, assign)ccTime timeLeft;
@property(nonatomic, assign)ccTime currentLevelTotalTime;
@property(nonatomic, assign)ccTime timeForNext;
@property(nonatomic, assign)NSUInteger currentLevel;

@property(nonatomic, assign)CGFloat shipProgress;

@end
