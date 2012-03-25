//
//  AHBuildTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHBuildTests.h"
#import "AHApplication.h"
#import "AHBuild.h"

@implementation AHBuildTests

- (void) testGetAllBuilds {
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	NSString *appID = [(AHApplication *) [applications objectAtIndex:0] slug];

	NSArray *builds = [AHBuild getAllByAppID:appID error:&error];
	
	STAssertNotNil(builds, @"builds are nil, you fail.");
	
}

- (void) testGetAllBuildsUsingCallback {
	
	__block BOOL done= NO;
    int count = 0;
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	NSString *appID = [(AHApplication *) [applications objectAtIndex:0] slug];
	
	[AHBuild getAllByAppID:appID 
			 usingCallback:^(NSArray *builds) {
				 STAssertNotNil(builds, @"builds were not returned, something went wrong.");
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

- (void) testGetBuild {
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	NSString *appID = [(AHApplication *) [applications objectAtIndex:0] slug];
	NSArray *builds = [AHBuild getAllByAppID:appID error:&error];
	NSString *buildURL = [(AHBuild *) [builds objectAtIndex:0] url];
	
	AHBuild *build = [AHBuild getByUrl:buildURL error:&error];
	STAssertNotNil(build, @"build is nil, you fail.");
	
}

- (void) testGetBuildUsingCallback {
	
	NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications =[AHApplication getAll:&localError];
	NSString *appID = [(AHApplication *) [applications objectAtIndex:0] slug];
	NSArray *builds = [AHBuild getAllByAppID:appID error:&localError];
	NSString *buildURL = [(AHBuild *) [builds objectAtIndex:0] url];
	
	[AHBuild getByUrl:buildURL 
		usingCallback:^(AHBuild *build) {
			STAssertNotNil(build, @"build was not returned, something went wrong.");
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
