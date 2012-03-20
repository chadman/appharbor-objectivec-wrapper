//
//  AppHarborAPIClientTests.m
//  AppHarborAPIClientTests
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppHarborAPIClientTests.h"
#import "AHAuthorize.h"

@implementation AppHarborAPIClientTests


- (void) testUserIsNotValid {
	
	[AHAuthorize killSettings];
	
	STAssertFalse([AHAuthorize isUserValid], @"user is valid, you fail.");
	
}

- (void) testUserIsValid {
	
	[AHAuthorize setAccessToken:@"testkey"];
	STAssertTrue([AHAuthorize isUserValid], @"user is not valid, you fail");
}

@end
