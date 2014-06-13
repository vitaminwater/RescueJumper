//
//  ProxyAim.h
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 4/4/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBDACenter.h"

@interface ProxyAim : NSObject<MissilAim> {
	
	NSObject<MissilAim> *delegate;
	
}

- (id)initWithDelegate:(NSObject<MissilAim> *)_delegate;

@end
