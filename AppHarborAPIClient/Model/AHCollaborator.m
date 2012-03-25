//
//  AHCollaborator.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHCollaborator.h"
#import "WebRequest.h"

@interface AHCollaborator (PRIVATE)

- (AHCollaborator *)initWithDictionary: (NSDictionary *)dict;

@end

@implementation AHCollaborator
@synthesize userID;
@synthesize userName;
@synthesize role;
@synthesize url;
@synthesize collaboratorEmail;
@synthesize appName;


#pragma mark - Data Methods

+ (NSArray *)getAllByAppID:(NSString *)appID error:(NSError **)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString * urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/collaborators", appID];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *collaborators = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[collaborators addObject:[AHCollaborator populateWithDictionary:value]];
		}
		
		return [collaborators copy];
	}
	
	return nil;
}

+ (void)getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString * urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/collaborators", appID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *collaborators = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  [collaborators addObject:[AHCollaborator populateWithDictionary:value]];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([collaborators copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

+ (AHCollaborator *) getByUserUrl:(NSString *)userUrl error:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:userUrl] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHCollaborator populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getByUserUrl:(NSString *)userUrl usingCallback:(void (^)(AHCollaborator *))collaborator errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:userUrl] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (collaborator) {
					  collaborator([AHCollaborator populateWithDictionary:returnedResults]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

- (BOOL) create:(NSError *__autoreleasing *)error {
	

	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString * urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/collaborators", self.appName];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"collaboratorEmail\":\"%@\",", self.collaboratorEmail];
	
	if (self.role == AHCollaboratorRoleAdministrator) {
	
		[json appendString:@"\"role\" : \"administrator\""];
	}
	else {
		[json appendString:@"\"role\" : \"collaborator\""];
	}
	[json appendString:@"}"];
	
	[request postWebRequest:[NSURL URLWithString:urlString]
			withContentType:WebRequestContentTypeJson 
				   withData:[json dataUsingEncoding:NSUTF8StringEncoding] 
				  withError:&*error];
	
	if (*error) {
		return NO;
	}
	
	return YES;
}

- (void) createUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error {

	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString * urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/collaborators", self.appName];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"collaboratorEmail\":\"%@\",", self.collaboratorEmail];
	if (self.role == AHCollaboratorRoleAdministrator) {
		
		[json appendString:@"\"role\" : \"administrator\""];
	}
	else {
		[json appendString:@"\"role\" : \"collaborator\""];
	}
	[json appendString:@"}"];

	[request postWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
				   withData:[json dataUsingEncoding:NSUTF8StringEncoding]  
			  usingCallback:^(id returnedResults) {
				  
				  isSuccessful(YES);
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}


#pragma mark - Population Methods

+ (AHCollaborator *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHCollaborator alloc] initWithDictionary:dict];
}

- (AHCollaborator *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	
	NSDictionary *userDict = [dict objectForKey:@"user"];
	
	if (userDict) {
		self.userID = [userDict objectForKey:@"id"];
		self.userName = [userDict objectForKey:@"name"];
	}
	
	if ([[userDict objectForKey:@"role"] isEqualToString:@"administrator"]) {
		self.role = AHCollaboratorRoleAdministrator;
	}
	else {
		self.role = AHCollaboratorRoleCollaborator;
	}
	self.url = [dict objectForKey:@"url"];
	
	return self;
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHCollaborator alloc] init];
	
	if (self != nil) {
		self.userID = [coder decodeObjectForKey:@"userID"];
		self.userName = [coder decodeObjectForKey:@"userName"];
		self.role = [coder decodeIntForKey:@"role"];
		self.url = [coder decodeObjectForKey:@"url"];
		self.collaboratorEmail = [coder decodeObjectForKey:@"collaboratorEmail"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	[coder encodeObject:userID forKey:@"userID"];
	[coder encodeObject:userName forKey:@"userName"];
	[coder encodeInteger:role forKey:@"role"];
	[coder encodeObject:url forKey:@"url"];
	[coder encodeObject:collaboratorEmail forKey:@"collaboratorEmail"];
}




@end
