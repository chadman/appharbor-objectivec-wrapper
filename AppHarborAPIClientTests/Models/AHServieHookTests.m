//
//  AHServieHookTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHServieHookTests.h"
#import "AHApplication.h"
#import "AHServiceHook.h"

@implementation AHServieHookTests

- (void) testGetAllServiceHooksByApplication {
	
	NSError *error = nil;
	
	NSArray *applications = [AHApplication getAll:&error];
	AHApplication *app = [applications objectAtIndex:1];
	
	NSArray *servicehooks = [AHServiceHook getAllByAppID:app.slug error:&error];
	
	STAssertNotNil(servicehooks, @"servciehooks are nil, you fail.");
	
}

- (void) testGetAllServiceHooksByApplicationUsingCallback {
	
	__block BOOL done= NO;
    int count = 0;
	
	NSError *error = nil;
	
	NSArray *applications = [AHApplication getAll:&error];
	AHApplication *app = [applications objectAtIndex:1];
	
	[AHServiceHook getAllByAppID:app.slug 
				   usingCallback:^(id servicehooks) {
					
					   STAssertNotNil(servicehooks, @"servicehooks were not returned, something went wrong.");
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

- (void) testGetServiceHooksByUrl {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	NSArray *servicehooks = [AHServiceHook getAllByAppID:appName error:&error];
	NSString *servicehookurl = [[servicehooks objectAtIndex:0] url];
	
	AHServiceHook *servicehook = [AHServiceHook getByUrl:servicehookurl error:&error];
	STAssertNotNil(servicehook, @"servicehook is nil, you fail.");
	
}

- (void) testGetServiceHooksByUrlUsingCallback {
	
	NSError *error = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	NSArray *servicehooks = [AHServiceHook getAllByAppID:appName error:&error];
	NSString *servicehookurl = [[servicehooks objectAtIndex:0] url];
	
	[AHServiceHook getByUrl:servicehookurl 
			  usingCallback:^(AHServiceHook *servicehook) {
				  STAssertNotNil(servicehook, @"servicehook was not returned, something went wrong.");
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

- (void) testCreateServiceHook {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	
	AHServiceHook *servicehook = [[AHServiceHook alloc] init];
	[servicehook setValue:@"http://www.objwrapper.com"];
	[servicehook setApplicationID:appName];
	[servicehook create:&error];
	
	BOOL isSuccessful = YES;
	
	if (error) {
		isSuccessful = NO;
	}
	
	if (isSuccessful) {
		NSArray *allServiceHooks = [AHServiceHook getAllByAppID:appName error:&error];
		
		for (AHServiceHook *currentServicehook in allServiceHooks) {
			if ([servicehook.value isEqualToString:currentServicehook.value]) {
				[currentServicehook delete:&error];
				break;
			}
		}
	}
	
	STAssertTrue(isSuccessful, @"servicehook was not saved.");
}

- (void) testCreateServiceHookUsingCallback {
	
	__block NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	
	AHServiceHook *servicehook = [[AHServiceHook alloc] init];
	[servicehook setValue:@"http://www.objwrapper.com"];
	[servicehook setApplicationID:appName];
	
	[servicehook createUsingCallback:^(NSString *location) {
		STAssertTrue([location length] > 0, @"creating hostname did not save.");
		done = YES;
		
		if ([location length] > 0) {
			NSArray *allServiceHooks = [AHServiceHook getAllByAppID:appName error:&localError];
			
			for (AHServiceHook *currentServicehook in allServiceHooks) {
				if ([servicehook.value isEqualToString:currentServicehook.value]) {
					[currentServicehook delete:&localError];
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

- (void) testReturnErrorForUrlValue {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	
	AHServiceHook *servicehook = [[AHServiceHook alloc] init];
	[servicehook setValue:@"objwrapper.com"];
	[servicehook setApplicationID:appName];
	[servicehook create:&error];
	
	STAssertEquals([error localizedDescription], @"the value must be an absolute url", @"error was not returned correctly");
	
	
}

- (void) testReturnYESForUrlValue {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:1] slug];
	
	AHServiceHook *servicehook = [[AHServiceHook alloc] init];
	[servicehook setValue:@"http://www.fiftytwo-projects.com"];
	[servicehook setApplicationID:appName];
	[servicehook create:&error];
	
	if ([[servicehook url] length] > 0) {
		NSArray *allServiceHooks = [AHServiceHook getAllByAppID:appName error:&error];
		
		for (AHServiceHook *currentServicehook in allServiceHooks) {
			if ([servicehook.value isEqualToString:currentServicehook.value]) {
				[currentServicehook delete:&error];
				break;
			}
		}
	}
	
	STAssertTrue([[servicehook url] length] > 0, @"service hook was not saved.");
	
	
}

@end
