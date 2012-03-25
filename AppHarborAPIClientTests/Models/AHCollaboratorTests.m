//
//  AHCollaboratorTests.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHCollaboratorTests.h"
#import "AHApplication.h"
#import "AHCollaborator.h"

@implementation AHCollaboratorTests

- (void) testGetAllCollaborators {
	
	NSError *error = nil;
	// Get all the applications so we can get the collaborators
	NSArray *applications = [AHApplication getAll:&error];	
	NSArray *collaborators = [AHCollaborator getAllByAppID:[(AHApplication *)[applications objectAtIndex:0] slug]  error:&error];
	STAssertNotNil(collaborators, @"collaborators were not populated, you fail.");
}


- (void) testGetAllCollaboratorsUsingCallback {
	
	NSError *error = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:0] slug];
	
	[AHCollaborator getAllByAppID:appName 
					usingCallback:^(NSArray *results) {
		
						STAssertNotNil(results, @"collaborators were not returned, something went wrong.");
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

- (void) testGetCollaborator {
	
	NSError *error = nil;
	// Get all the applications so we can get the collaborators
	NSArray *applications = [AHApplication getAll:&error];	
	NSArray *collaborators = [AHCollaborator getAllByAppID:[(AHApplication *)[applications objectAtIndex:0] slug]  error:&error];
	
	AHCollaborator *collaborator = [AHCollaborator getByUserUrl:[(AHCollaborator *) [collaborators objectAtIndex:0] url] 														 
														  error:&error];
	
	STAssertNotNil(collaborator, @"collaborator was not populated, you fail.");
	
}

- (void) testGetCollaboratorUsingCallback {
	NSError *error = nil;
	__block BOOL done= NO;
    int count = 0;
	NSArray *applications = [AHApplication getAll:&error];
	NSString *appName = [(AHApplication *)[applications objectAtIndex:0] slug];
	NSArray *collaborators = [AHCollaborator getAllByAppID:appName error:&error];
	
	[AHCollaborator getByUserUrl:[(AHCollaborator *) [collaborators objectAtIndex:0] url] 
				  usingCallback:^(AHCollaborator *collaborator) {
						
						STAssertNotNil(collaborator, @"collaborator was not returned, something went wrong.");
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

- (void) testCreateCollaborator {
	
	NSError *error = nil;
	NSArray *applications = [AHApplication getAll:&error];	
	
	AHCollaborator *collaborator = [[AHCollaborator alloc] init];
	[collaborator setRole:AHCollaboratorRoleCollaborator];
	[collaborator setCollaboratorEmail:@"daneiacwow@gmail.com"];
	[collaborator setAppName:[(AHApplication *)[applications objectAtIndex:0] slug]];
	[collaborator create:&error];
}

@end
