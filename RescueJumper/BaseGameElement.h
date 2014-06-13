//
//  BaseGameElement.h
//  RescueJumper
//
//  Created by Constantin on 8/12/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LevelElementGenerator;
@class BaseGameElement;

@protocol GameElementDelegate <NSObject>

- (void)gameElementRemoved:(BaseGameElement *)gameElement;

@end

@interface BaseGameElement : NSObject {
    
    NSObject<GameElementDelegate> *delegate;
    NSUInteger player;
    
}

@property(nonatomic, assign)NSObject<GameElementDelegate> *delegate;
@property(nonatomic, assign)NSUInteger player;

- (CGRect)collidRect;

@end
