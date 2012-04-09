//
//  AHHostnameTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHHostnameTests.h"
#import "AHApplication.h"
#import "AHHostname.h"

@implementation AHHostnameTests



- (void) testGetAllHostnamesByApplication {
	
	NSError *error = nil;
	
	NSArray *applications = [AHApplication getAll:&error];
	AHApplication *app = [applications objectAtIndex:1];
	
	NSArray *hostnames = [AHHostname getAllByAppID:app.slug error:&error];
	
	STAssertNotNil(hostnames, @"hostanmes are nil, you fail.");
	
}

- (void) testGetAllHostnamesByApplicationUsingCallback {
	
	__block BOOL done= NO;
    int count = 0;
	
	NSError *error = nil;
	
	NSArray *applications = [AHApplication getAll:&error];
	AHApplication *app = [applications objectAtIndex:1];
	
	[AHHostname getAllByAppID:app.slug 
				usingCallback:^(id hostnames) {
		
					STAssertNotNil(hostnames, @"hostnames were not returned, something went wrong.");
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

- (void) testGetHostnamesByUrl {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	NSArray *hostnames = [AHHostname getAllByAppID:appName error:&error];
	NSString *hostnameURL = [[hostnames objectAtIndex:0] url];
	
	AHHostname *hostname = [AHHostname getByUrl:hostnameURL error:&error];
	STAssertNotNil(hostname, @"hostname is nil, you fail.");
	
}

- (void) testGetHostnamesByUrlUsingCallback {
	
	NSError *error = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	NSArray *hostnames = [AHHostname getAllByAppID:appName error:&error];
	NSString *hostnameURL = [[hostnames objectAtIndex:0] url];
	
	[AHHostname getByUrl:hostnameURL 
		   usingCallback:^(AHHostname *hostname) {
			   STAssertNotNil(hostname, @"hostname was not returned, something went wrong.");
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

- (void) testCreateHostname {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	
	AHHostname *hostname = [[AHHostname alloc] init];
	[hostname setValue:@"objwrapper.com"];
	[hostname setApplicationID:appName];
	[hostname create:&error];
	
	BOOL isSuccessful = YES;
	
	if (error) {
		isSuccessful = NO;
	}
	
	if (isSuccessful) {
		NSArray *allHostnames = [AHHostname getAllByAppID:appName error:&error];
								 
		for (AHHostname *host in allHostnames) {
			if ([host.value isEqualToString:hostname.value]) {
				[host delete:&error];
			}
		}
	}
	
	STAssertTrue(isSuccessful, @"hostname was not saved.");
}

- (void) testCreateHostnameUsingCallback {
	
	__block NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	
	AHHostname *hostname = [[AHHostname alloc] init];
	[hostname setValue:@"objwrapper.com"];
	[hostname setApplicationID:appName];
	
	[hostname createUsingCallback:^(NSString * returnLocation) {
		STAssertTrue([returnLocation length] > 0, @"creating hostname did not save.");
		done = YES;
		
		if ([returnLocation length] > 0) {
			NSArray *allHostnames = [AHHostname getAllByAppID:appName error:&localError];
			
			for (AHHostname *host in allHostnames) {
				if ([host.value isEqualToString:hostname.value]) {
					[host delete:&localError];
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
