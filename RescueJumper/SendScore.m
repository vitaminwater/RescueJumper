//
//  SendScore.m
//  RescueJumper
//
//  Created by stant on 10/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "SendScore.h"

#import "GDataXMLNode.h"

#import "StatItem.h"

@interface SendScore()

- (id)initWithStats:(NSArray *)stats;

@end

@implementation SendScore

- (id)initWithStats:(NSArray *)stats {
	
	if (self = [super init]) {
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://stats.rescuejumper.com/why_the_fuck_would_you_do_this.php"]];
		
		GDataXMLElement *root = [GDataXMLElement elementWithName:@"Stats"];
		for (StatItem *item in stats) {
			GDataXMLElement *statElement = [GDataXMLElement elementWithName:NSStringFromClass([item class])];
			[statElement addChild:[GDataXMLElement elementWithName:@"name" stringValue:[NSString stringWithFormat:@"%d", item.key]]];
			[statElement addChild:[GDataXMLElement elementWithName:@"n" stringValue:[NSString stringWithFormat:@"%d", (int)[item resultN]]]];
			[statElement addChild:[GDataXMLElement elementWithName:@"total" stringValue:[NSString stringWithFormat:@"%d", (int)[item resultPts]]]];
			[root addChild:statElement];
		}
		
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:root];
		request.HTTPMethod = @"POST";
		request.HTTPBody = document.XMLData;
		[request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
		
		NSLog(@"%@", [NSString stringWithUTF8String:[document.XMLData bytes]]);
        [document release];
		
		connection = [NSURLConnection connectionWithRequest:request delegate:self];
	}
	return self;
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

+ (void)sendScore:(NSArray *)stats {
	[[[self alloc] initWithStats:stats] release];
}

@end
