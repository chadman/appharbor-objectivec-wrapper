//
//  AHApplicationTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHApplicationTests.h"
#import "AHApplication.h"

@implementation AHApplicationTests


- (void) testGetAllApplications {
	
	NSError *error = nil;
	
	NSArray *applications = [AHApplication getAll:&error];
	
	STAssertNotNil(applications, @"applications are nil, you fail.");
	
}


@end
