//
//  AHApplicationTests.h
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "BaseTests.h"

@interface AHApplicationTests : BaseTests

- (void) testGetAllApplications;

- (void) testGetAllApplicationsUsingCallback;

- (void) testGetApplicationByID;

- (void) testGetAllicationByIDUsingCallback;

- (void) testCreateApplication;

- (void) testCreateApplicationUsingCallback;

@end
