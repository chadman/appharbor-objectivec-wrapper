//
//  AHTestTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHTestTests.h"
#import "AHApplication.h"
#import "AHBuild.h"
#import "AHTest.h"

@implementation AHTestTests

- (void) testGetAllTests {
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	NSString *appID = [(AHApplication *) [applications objectAtIndex:1] slug];
	NSArray *builds = [AHBuild getAllByAppID:appID error:&error];
	NSString *testUrl = [(AHBuild *) [builds objectAtIndex:0] testsUrl];
	
	NSArray *tests = [AHTest getAllByUrl:testUrl error:&error];
	
	STAssertNotNil(tests, @"tests are nil, you fail.");
	
}

- (void) testGetAllTestsUsingCallback {
	
	__block BOOL done = NO;
    int count = 0;
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	NSString *appID = [(AHApplication *) [applications objectAtIndex:1] slug];
	NSArray *builds = [AHBuild getAllByAppID:appID error:&error];
	NSString *testUrl = [(AHBuild *) [builds objectAtIndex:0] testsUrl];
	
	
	[AHTest getAllByUrl:testUrl usingCallback:^(NSArray *tests) {
		STAssertNotNil(tests, @"tests were not returned, something went wrong.");
		done = YES;
	}
				errorBlock:^(NSError *error) {
					STFail([NSString stringWithFormat:@"An error occured. %@", error]);
					done = YES;							
				}
	 ];
	
	
	while (!done) {
        
        if (count < 20) {
            count++;
            [self runLoop];
        }
        else {
            done = YES;
            STFail(@"Did not complete testGetAllUsingCallback");
        }
    }
}
@end
