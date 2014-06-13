//
//  ContactGameElement.h
//  RescueJumper
//
//  Created by Constantin on 8/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "InteractiveElement.h"

@class Bipede;

@interface ContactElement : InteractiveElement

- (BOOL)execute:(Bipede *)bipede dt:(ccTime)dt;
- (BOOL)testCollid:(Bipede *)bipede dt:(ccTime)dt;
- (BOOL)checkBipede:(ccTime)dt bipede:(Bipede *)bipede;

@end
