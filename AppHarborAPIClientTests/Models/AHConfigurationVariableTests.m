//
//  AHConfigurationVariableTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHConfigurationVariableTests.h"
#import "AHApplication.h"
#import "AHConfigurationVariable.h"

@implementation AHConfigurationVariableTests

- (void) testGetAllConfigurationVariables {
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	
	NSArray *configurationVariables = [AHConfigurationVariable getAllByAppID:[(AHApplication *) [applications objectAtIndex:0] slug] error:&error];
	
	STAssertNotNil(configurationVariables, @"configuration variables are nil, you fail.");
	
}

- (void) testGetAllConfigurationVariablesUsingCallback {
	
	__block BOOL done= NO;
    int count = 0;
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	
	[AHConfigurationVariable getAllByAppID:[(AHApplication *) [applications objectAtIndex:0] slug] 
							 usingCallback:^(id configurationVariables) {
		
		STAssertNotNil(configurationVariables, @"configuration variables were not returned, something went wrong.");
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

- (void) testGetConfigurationVariableByUrl {
	
	NSError *error = nil;
	NSArray *applications =[AHApplication getAll:&error];
	NSArray *configurationVariables = [AHConfigurationVariable getAllByAppID:[(AHApplication *) [applications objectAtIndex:0] slug] error:&error];
	
	AHConfigurationVariable *configVariable = [AHConfigurationVariable getByUrl:[(AHConfigurationVariable *) [configurationVariables objectAtIndex:0] url] error:&error];
	STAssertNotNil(configVariable, @"configuration variable is nil, you fail.");
	
}

- (void) testGetConfigurationVariableByUrlUsingCallback {
	
	NSError *error = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications =[AHApplication getAll:&error];
	NSArray *configurationVariables = [AHConfigurationVariable getAllByAppID:[(AHApplication *) [applications objectAtIndex:0] slug] error:&error];
	
	[AHConfigurationVariable getByUrl:[(AHConfigurationVariable *) [configurationVariables objectAtIndex:0] url]
						usingCallback:^(AHConfigurationVariable *configVariable) {
				   STAssertNotNil(configVariable, @"configuration variable was not returned, something went wrong.");
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

- (void) testCreateConfigurationVariable {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];

	AHConfigurationVariable *configVariable = [[AHConfigurationVariable alloc] init];
	[configVariable setKey:@"foo"];
	[configVariable setValue:@"bar"];
	[configVariable createWithAppID:[(AHApplication *) [applications objectAtIndex:0] slug] error:&error];
	
	BOOL isSuccessful = YES;
	
	if (error) {
		isSuccessful = NO;
	}
	
	if (isSuccessful) {
		NSArray *allConfigurationVariables = [AHConfigurationVariable getAllByAppID:[(AHApplication *) [applications objectAtIndex:0] slug] error:&error];
		
		for (AHConfigurationVariable *current in allConfigurationVariables) {
			if ([current.key isEqualToString:configVariable.key]) {
				[current delete:&error];
			}
		}
	}
	
	STAssertTrue(isSuccessful, @"configuration variable was not saved.");
}

- (void) testCreateConfigurationVariableUsingCallback {
	
	__block NSError *localError = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications = [AHApplication getAll:&localError];
	
	AHConfigurationVariable *configVariable = [[AHConfigurationVariable alloc] init];
	[configVariable setKey:@"foo"];
	[configVariable setValue:@"bar"];
	[configVariable createWithAppID:[(AHApplication *) [applications objectAtIndex:0] slug] 
					  usingCallback:^(BOOL isSuccessful) {
							STAssertTrue(isSuccessful, @"creating application did not save.");
							done = YES;
							
							if (isSuccessful) {
								NSArray *allConfigurationVariables = [AHConfigurationVariable getAllByAppID:[(AHApplication *) [applications objectAtIndex:0] slug] error:&localError];
								
								for (AHConfigurationVariable *current in allConfigurationVariables) {
									if ([current.key isEqualToString:configVariable.key]) {
										[current delete:&localError];
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
