//
//  AHApplication.m
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHApplication.h"
#import "WebRequest.h"
#import "AHUserDefaults.h"

@interface AHApplication (PRIVATE)

- (AHApplication *)initWithDictionary: (NSDictionary *)dict;

@end


@implementation AHApplication
@synthesize name;
@synthesize slug;
@synthesize url;


#pragma mark - Data Methods

+ (NSArray *)getAll:(NSError **)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:@"https://appharbor.com/applications"] 
									 withContentType:WebRequestContentTypeJson 
										   withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *applications = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[applications addObject:[AHApplication populateWithDictionary:value]];
		}
		
		return [applications copy];
	}
	
	return nil;
}

+ (void)getAllUsingCallback:(void (^)(NSArray *))resultsBlock error:(void (^)(NSError *))errorBlock {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:@"https://appharbor.com/applications"] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *applications = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {

					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  [applications addObject:[AHApplication populateWithDictionary:value]];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([applications copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (errorBlock) {
						 errorBlock(localError);
					 }
				 }
	 ];
}

+ (AHApplication *) getBySlug:(NSString *)appSlug error:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@", appSlug];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];

	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHApplication populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getBySlug:(NSString *)appSlug usingCallback:(void (^)(AHApplication *))application errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@", appSlug];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (application) {
					  application([AHApplication populateWithDictionary:returnedResults]);
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
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"name\":\"%@\",", self.name];
	[json appendString:@"\"region_identifier\" : \"amazon-web-services::us-east-1\""];
	[json appendString:@"}"];
	
	[request postWebRequest:[NSURL URLWithString:@"https://appharbor.com/applications"] 
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
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"name\":\"%@\",", self.name];
	[json appendString:@"\"region_identifier\" : \"amazon-web-services::us-east-1\""];
	[json appendString:@"}"];
	
	[request postWebRequest:[NSURL URLWithString:@"https://appharbor.com/applications"] 
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

- (BOOL) update:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@", self.slug];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"name\":\"%@\"", self.name];
	[json appendString:@"}"];
	
	[request putWebRequest:[NSURL URLWithString:urlString] 
		   withContentType:WebRequestContentTypeJson 
				  withData:[json dataUsingEncoding:NSUTF8StringEncoding] 
				 withError:&*error];
	
	if (*error) {
		return NO;
	}
	
	return YES;
}

- (void) updateUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@", self.slug];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"name\":\"%@\"", self.name];
	[json appendString:@"}"];
	
	[request putWebRequest:[NSURL URLWithString:urlString] 
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
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@", self.slug];
	
	[request deleteWebRequest:[NSURL URLWithString:urlString] 
			  withContentType:WebRequestContentTypeJson 
					withError:&*error];
	
	if (*error) {
		return NO;
	}
	
	return YES;
}

- (void) deleteUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@", self.slug];
	
	[request deleteWebRequest:[NSURL URLWithString:urlString] 
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

+ (AHApplication *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHApplication alloc] initWithDictionary:dict];
}

- (AHApplication *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];

	self.name = [dict objectForKey:@"name"];
	self.slug = [dict objectForKey:@"slug"];
	self.url = [dict objectForKey:@"url"];
	
	return self;
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHApplication alloc] init];
	
	if (self != nil) {
		self.name = [coder decodeObjectForKey:@"name"];
		self.slug = [coder decodeObjectForKey:@"slug"];
		self.url = [coder decodeObjectForKey:@"url"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:slug forKey:@"slug"];
	[coder encodeObject:url forKey:@"url"];
}


@end
