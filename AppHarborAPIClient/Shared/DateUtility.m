//
//  DateUtility.m
//  F1Touch
//
//  Created by Matt Vasquez on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DateUtility.h"


@implementation DateUtility

+ (NSDate *)dateAndTimeFromString:(NSString *)dateString {
		
	if (dateString != nil) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
		NSDate *date = [df dateFromString:dateString];
		
		if (!date) {
			[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
			date = [df dateFromString:dateString];
		}
		return date;	
	}
	else {
		return nil;
	}
}

+ (NSDate *)dateFromString:(NSString *)dateString {
	
	if (dateString != nil) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd"];
		NSDate *date = [df dateFromString:dateString];
		return date;	
	}
	else {
		return nil;
	}
}

+ (NSString *)stringFromDate:(NSDate *)date {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd MMM yyyy"];
	NSString *stringDate = [df stringFromDate:date];
	return stringDate;
}

+ (NSString *)stringFromDateAndTimeFrom:(NSDate *)date {
	
	if (date != nil) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
		NSString *dateString = [df stringFromDate:date];
		return dateString;	
	}
	else {
		return nil;
	}
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormat: (NSString *)format {
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setFormatterBehavior:NSDateFormatterBehavior10_4];
	[df setDateFormat:format];
	NSString *stringDate = [df stringFromDate:date];
	return stringDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat: (NSString *)format {
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
	NSDate *date = [df dateFromString:dateString];
	return date;	
}

@end
