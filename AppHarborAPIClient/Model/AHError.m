//
//  AHError.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHError.h"
#import "WebRequest.h"
#import "Utility.h"

@interface AHError (PRIVATE)

- (AHError *)initWithDictionary: (NSDictionary *)dict;

@end


@implementation AHError
@synthesize commitID;
@synthesize date;
@synthesize requestPath;
@synthesize message;
@synthesize exceptionStackTrace;
@synthesize exceptionMessage;
@synthesize exceptionType;
@synthesize innerException;
@synthesize url;


+ (NSArray *)getAllByAppID: (NSString *)appID error:(NSError **)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/errors", appID];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *errors = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[errors addObject:[AHError populateWithDictionary:value]];
		}
		
		return [errors copy];
	}
	
	return nil;
}

+ (void)getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error {	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/errors", appID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *errors = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  // Go through each one and add to the applications to an array
				  for (NSDictionary *value in returnedResults) {
					  [errors addObject:[AHError populateWithDictionary:value]];
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([errors copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

+ (AHError *) getByUrl:(NSString *)url error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:url] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHError populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getByUrl:(NSString *)url usingCallback:(void (^)(AHError *))appError errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:url] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (appError) {
					  appError([AHError populateWithDictionary:returnedResults]);
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

+ (AHError *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHError alloc] initWithDictionary:dict];
}

- (AHError *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	
	self.commitID = [dict objectForKey:@"commit_id"];
	self.date = [AHUtility convertToFullNSDate:[dict objectForKey:@"date"]];
	self.requestPath = [dict objectForKey:@"request_path"];
	self.message = [dict objectForKey:@"message"];
	
	NSDictionary *exceptionDictionary = [dict objectForKey:@"exception"];
	
	if (exceptionDictionary) {
		self.exceptionStackTrace = [exceptionDictionary objectForKey:@"stack_trace"];
		self.exceptionMessage = [exceptionDictionary objectForKey:@"message"];
		self.exceptionType = [exceptionDictionary objectForKey:@"type"];
		self.innerException = [exceptionDictionary objectForKey:@"inner_exception"];
	}
	
	self.url = [dict objectForKey:@"url"];
						 
	
	return self;
}

#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHError alloc] init];
	
	if (self != nil) {
		self.commitID = [coder decodeObjectForKey:@"commitID"];
		self.date = [coder decodeObjectForKey:@"date"];
		self.requestPath = [coder decodeObjectForKey:@"requestPath"];
		self.message = [coder decodeObjectForKey:@"message"];
		self.exceptionStackTrace = [coder decodeObjectForKey:@"exceptionStackTrace"];
		self.exceptionMessage = [coder decodeObjectForKey:@"exceptionMessage"];
		self.exceptionType = [coder decodeObjectForKey:@"exceptionType"];
		self.innerException = [coder decodeObjectForKey:@"innerException"];
		self.url = [coder decodeObjectForKey:@"url"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:commitID forKey:@"commitID"];
	[coder encodeObject:date forKey:@"date"];
	[coder encodeObject:requestPath forKey:@"requestPath"];
	[coder encodeObject:message forKey:@"message"];
	[coder encodeObject:exceptionStackTrace forKey:@"exceptionStackTrace"];
	[coder encodeObject:exceptionMessage forKey:@"exceptionMessage"];
	[coder encodeObject:exceptionType forKey:@"exceptionType"];
	[coder encodeObject:innerException forKey:@"innerException"];
	[coder encodeObject:url forKey:@"url"];
}



@end
