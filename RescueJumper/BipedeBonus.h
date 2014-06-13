//
//  BipedeBonus.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/21/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DisplayObject;
@class Bipede;
@class Game;

@interface BipedeBonus : NSObject {
	
	Bipede *bipede;
	DisplayObject *sprite;
	Game *game;
	
}

@property(nonatomic, readonly)DisplayObject *sprite;
@property(nonatomic, readonly)Bipede *bipede;

- (id)initWithBipede:(Bipede *)_bipede game:(Game *)_game;
- (void)execute;
- (void)bipedeSizeChanged;
- (void)bipedePlayerChanged:(NSUInteger)from to:(NSUInteger)to;
- (NSString *)bonusSprite;

@end
