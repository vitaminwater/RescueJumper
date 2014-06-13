//
//  SendScore.h
//  RescueJumper
//
//  Created by stant on 10/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendScore : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
	
	NSURLConnection *connection;
	
}

+ (void)sendScore:(NSArray *)stats;

@end
