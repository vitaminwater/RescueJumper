//
//  BaseGameLevel.h
//  RescueJumper
//
//  Created by Constantin on 10/20/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@protocol BaseGameLevel <NSObject>

- (BOOL)canPlay;
- (NSString *)getLevelIcon;
- (void)initGame:(Game *)game;

@end
