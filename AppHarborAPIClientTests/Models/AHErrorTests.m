//
//  AHErrorTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHErrorTests.h"
#import "AHError.h"
#import "AHApplication.h"

@implementation AHErrorTests

- (void) testGetAllByAppID {
	
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	AHApplication *app = [applications objectAtIndex:1];
	
	NSArray *errors = [AHError getAllByAppID:app.slug error:&error];
	STAssertNotNil(errors, @"errors are nil, you fail.");
	

	
}

- (void) testGetAllByAppIDUsingCallback {
	
	NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	
	NSArray *applications =[AHApplication getAll:&localError];
	AHApplication *app = [applications objectAtIndex:1];
	
	[AHError getAllByAppID:app.slug 
			 usingCallback:^(NSArray *returnedErrors) {
		
				 STAssertNotNil(returnedErrors, @"errors was not returned, something went wrong.");
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

- (void) testGetByUrl {
	
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	AHApplication *app = [applications objectAtIndex:1];
	
	NSArray *errors = [AHError getAllByAppID:app.slug error:&error];
	AHError *appError = [errors objectAtIndex:0];
	
	AHError *returnedError = [AHError getByUrl:[appError url] error:&error];
	STAssertNotNil(returnedError, @"error are nil, you fail.");
	
}

- (void) testGetByUrlUsingCallback {
	
	NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	
	NSArray *applications =[AHApplication getAll:&localError];
	AHApplication *app = [applications objectAtIndex:1];
	
	NSArray *errors = [AHError getAllByAppID:app.slug error:&localError];
	AHError *appError = [errors objectAtIndex:0];
	
	[AHError getByUrl:[appError url] 
		usingCallback:^(AHError *returnError) {
				 
			STAssertNotNil(returnError, @"error was not returned, something went wrong.");
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
