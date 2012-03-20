//
//  BaseTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseTests.h"

@implementation BaseTests

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

@end
