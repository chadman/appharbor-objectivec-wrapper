//
//  BaseTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseTests.h"
#import "AHAuthorize.h"
#import "AHTestsConstants.h"

@implementation BaseTests

- (void)setUp
{
    [super setUp];
	
	[AHAuthorize setClientID:kAppHarborTestClientID withSecrect:kAppHarborTestClientSecret];
	[AHAuthorize setAccessToken:kAppHarborTestAccessToken];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
	[AHAuthorize killSettings];
}

- (void) runLoop {
    
    @try {
        // This executes another run loop.
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        // Sleep 1/100th sec
        usleep(10000);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	
}
@end
