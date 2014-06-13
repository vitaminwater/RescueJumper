//
//  CoinBonus.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/6/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ContactElement.h"

@interface CoinBonus : ContactElement {
    
    NSUInteger value;
    
}

- (id)initWithGame:(Game *)_game value:(CGFloat)_value;

@end
