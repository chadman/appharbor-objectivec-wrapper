//
//  AHHostnames.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHHostname.h"
#import "WebRequest.h"
#import "AHUserDefaults.h"
#import "Utility.h"

@interface AHHostname (PRIVATE)

- (AHHostname *)initWithDictionary: (NSDictionary *)dict;

@end


@implementation AHHostname
@synthesize value;
@synthesize canonical;
@synthesize url;
@synthesize applicationID;


#pragma mark - Data Methods

+ (NSArray *)getAllByAppID:(NSString *)appID error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/hostnames", appID];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *hostnames = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			AHHostname *currentHostName = [AHHostname populateWithDictionary:value];
			[currentHostName setApplicationID:appID];
			[hostnames addObject:currentHostName];
		}
		
		return [hostnames copy];
	}
	
	return nil;
}

+ (void) getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock error:(void (^)(NSError *))errorBlock {
	

	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/hostnames", appID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *hostnames = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  AHHostname *currentHostName = [AHHostname populateWithDictionary:value];
						  [currentHostName setApplicationID:appID];
						  [hostnames addObject:currentHostName];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([hostnames copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (errorBlock) {
						 errorBlock(localError);
					 }
				 }
	 ];

}

+ (AHHostname *)getByUrl:(NSString *)url error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:url] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHHostname populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getByUrl:(NSString *)url usingCallback:(void (^)(AHHostname *))hostname errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:url] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (hostname) {
					  hostname([AHHostname populateWithDictionary:returnedResults]);
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
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/hostnames", self.applicationID];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"value\":\"%@\"", self.value];
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
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/hostnames", self.applicationID];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"value\":\"%@\"", self.value];
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

- (BOOL) delete:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request deleteWebRequest:[NSURL URLWithString:url] 
			  withContentType:WebRequestContentTypeJson 
					withError:&*error];
	
	if (*error) {
		return NO;
	}
	
	return YES;
}

- (void) deleteUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request deleteWebRequest:[NSURL URLWithString:url] 
			  withContentType:WebRequestContentTypeJson  
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

+ (AHHostname *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHHostname alloc] initWithDictionary:dict];
}

- (AHHostname *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];

	self.url = [dict objectForKey:@"url"];
	self.value = [dict objectForKey:@"value"];
	self.canonical = [AHUtility convertToInt:[dict objectForKey:@"canonical"]];
	
	return self;
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHHostname alloc] init];
	
	if (self != nil) {
		self.value = [coder decodeObjectForKey:@"value"];
		self.canonical = [coder decodeBoolForKey:@"canonical"];
		self.url = [coder decodeObjectForKey:@"url"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:value forKey:@"value"];
	[coder encodeBool:canonical forKey:@"canonical"];
	[coder encodeObject:url forKey:@"url"];
}


@end
