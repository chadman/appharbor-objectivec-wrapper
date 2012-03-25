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

- (void) testGetAllApplicationsUsingCallback {
	
	__block BOOL done= NO;
    int count = 0;
	
	[AHApplication getAllUsingCallback:^(id applications) {
		
		STAssertNotNil(applications, @"applications were not returned, something went wrong.");
		done = YES;
		
		
	}
								 error:^(NSError *error) {
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

- (void) testGetApplicationByID {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:0] slug];
	
	AHApplication *application = [AHApplication getBySlug:appName error:&error];
	STAssertNotNil(application, @"application is nil, you fail.");
		
}

- (void) testGetAllicationByIDUsingCallback {
	
	NSError *error = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:0] slug];
	
	
	
	[AHApplication getBySlug:appName 
			   usingCallback:^(AHApplication *application) {
				   STAssertNotNil(application, @"application was not returned, something went wrong.");
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

- (void) testCreateApplication {
	
	NSError *error = nil;
	AHApplication *application = [[AHApplication alloc] init];
	[application setName:@"Wrapper Test Site"];
	[application create:&error];
	
	BOOL isSuccessful = YES;
	
	if (error) {
		isSuccessful = NO;
	}
	
	if (isSuccessful) {
		NSArray *allApplications = [AHApplication getAll:&error];
		
		for (AHApplication *app in allApplications) {
			if ([app.name isEqualToString:application.name]) {
				[app delete:&error];
			}
		}
	}
	
	STAssertTrue(isSuccessful, @"application was not saved.");
}

- (void) testCreateApplicationUsingCallback {
	
	__block NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	
	AHApplication *application = [[AHApplication alloc] init];
	[application setName:@"Wrapper Test Site Callback"];
	
	[application createUsingCallback:^(BOOL isSuccessful) {
					STAssertTrue(isSuccessful, @"creating application did not save.");
					done = YES;
		
					if (isSuccessful) {
						NSArray *allApplications = [AHApplication getAll:&localError];
						
						for (AHApplication *app in allApplications) {
							if ([app.name isEqualToString:application.name]) {
								[app delete:&localError];
							}
						}
					}
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
