//
//  NSString+decode64.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+decode64.h"

@implementation NSString (decode64)

- (NSString *) decodeBase64 {

	NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-";
	NSString *decoded = @"";
	NSString *encoded = [self stringByPaddingToLength:(ceil([self length] / 4) * 4)
											withString:@"A"
									   startingAtIndex:0];
	
	int i;
	char a, b, c, d;
	UInt32 z;
	
	for(i = 0; i < [encoded length]; i += 4) {
		a = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 0, 1)]].location;
		b = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 1, 1)]].location;
		c = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 2, 1)]].location;
		d = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 3, 1)]].location;
		
		z = ((UInt32)a << 26) + ((UInt32)b << 20) + ((UInt32)c << 14) + ((UInt32)d << 8);
		decoded = [decoded stringByAppendingString:[NSString stringWithCString:(char *)&z]];
	}
	
	
	return decoded;
}

@end
