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
	
	[AHAuthorize setClientID:kAppHarborClientID withSecrect:kAppHarborClientSecret];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
	[AHAuthorize killSettings];
}


@end
