//
//  AHHostnameTests.h
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "BaseTests.h"

@interface AHHostnameTests : BaseTests

- (void) testGetAllHostnamesByApplication;

- (void) testGetAllHostnamesByApplicationUsingCallback;

- (void) testGetHostnamesByUrl;

- (void) testGetHostnamesByUrlUsingCallback;

- (void) testCreateHostname;

- (void) testCreateHostnameUsingCallback;

@end
