//
//  AHServieHookTests.h
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "BaseTests.h"

@interface AHServieHookTests : BaseTests

- (void) testGetAllServiceHooksByApplication;

- (void) testGetAllServiceHooksByApplicationUsingCallback;

- (void) testGetServiceHooksByUrl;

- (void) testGetServiceHooksByUrlUsingCallback;

- (void) testCreateServiceHook;

- (void) testCreateServiceHookUsingCallback;

- (void) testReturnErrorForUrlValue;

- (void) testReturnYESForUrlValue;

@end
