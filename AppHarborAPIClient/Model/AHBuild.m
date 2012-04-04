//
//  AHBuild.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHBuild.h"
#import "WebRequest.h"
#import "AHUserDefaults.h"
#import "Utility.h"

@interface AHBuild (PRIVATE)

- (AHBuild *)initWithDictionary: (NSDictionary *)dict;

@end

@implementation AHBuild
@synthesize status;
@synthesize created;
@synthesize deployed;
@synthesize commitID;
@synthesize commitMessage;
@synthesize downloadUrl;
@synthesize testsUrl;
@synthesize url;




#pragma mark - Data Methods

+ (NSArray *)getAllByAppID:(NSString *)appID error:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/builds", appID];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *builds = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[builds addObject:[AHBuild populateWithDictionary:value]];
		}
		
		return [builds copy];
	}
	
	return nil;
}

+ (void)getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error {	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/builds", appID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				 NSMutableArray *builds = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  [builds addObject:[AHBuild populateWithDictionary:value]];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([builds copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

+ (AHBuild *) getByUrl:(NSString *)url error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:url] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHBuild populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getByUrl:(NSString *)url usingCallback:(void (^)(AHBuild *))configurationVariable errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:url] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (configurationVariable) {
					  configurationVariable([AHBuild populateWithDictionary:returnedResults]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}


#pragma mark - Population Methods

+ (AHBuild *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHBuild alloc] initWithDictionary:dict];
}

- (AHBuild *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	
	self.status = [dict objectForKey:@"status"];
	self.created = [AHUtility convertToFullNSDate:[dict objectForKey:@"created"]];
	self.deployed = [AHUtility convertToFullNSDate:[dict objectForKey:@"deployed"]];
	
	NSDictionary *commit = [dict objectForKey:@"commit"];
	
	if (commit) {
		self.commitID = [commit objectForKey:@"id"];
		self.commitMessage = [commit objectForKey:@"message"];
	}
	
	self.downloadUrl = [dict objectForKey:@"download_url"];
	self.testsUrl = [dict objectForKey:@"tests_url"];
	self.url = [dict objectForKey:@"url"];
	
	return self;
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHBuild alloc] init];
	
	if (self != nil) {
		self.status = [coder decodeObjectForKey:@"status"];
		self.created = [coder decodeObjectForKey:@"created"];
		self.deployed = [coder decodeObjectForKey:@"deployed"];
		self.commitID = [coder decodeObjectForKey:@"commitID"];
		self.commitMessage = [coder decodeObjectForKey:@"commitMessage"];
		self.downloadUrl = [coder decodeObjectForKey:@"downloadUrl"];
		self.testsUrl = [coder decodeObjectForKey:@"testsUrl"];
		self.url = [coder decodeObjectForKey:@"url"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:status forKey:@"status"];
	[coder encodeObject:created forKey:@"created"];
	[coder encodeObject:deployed forKey:@"deployed"];
	[coder encodeObject:commitID forKey:@"commitID"];
	[coder encodeObject:commitMessage forKey:@"commitMessage"];
	[coder encodeObject:downloadUrl forKey:@"downloadUrl"];
	[coder encodeObject:testsUrl forKey:@"testsUrl"];
	[coder encodeObject:url forKey:@"url"];
}


@end
