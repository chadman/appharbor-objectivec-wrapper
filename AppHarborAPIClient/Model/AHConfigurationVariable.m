//
//  AHConfigurationVariable.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHConfigurationVariable.h"
#import "WebRequest.h"
#import "AHUserDefaults.h"

@interface AHConfigurationVariable (PRIVATE)

- (AHConfigurationVariable *)initWithDictionary: (NSDictionary *)dict;

@end


@implementation AHConfigurationVariable
@synthesize key;
@synthesize value;
@synthesize url;


#pragma mark - Data Methods

+ (NSArray *)getAllByAppID:(NSString *)appID error:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/configurationvariables", appID];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *configurationVariables = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[configurationVariables addObject:[AHConfigurationVariable populateWithDictionary:value]];
		}
		
		return [configurationVariables copy];
	}
	
	return nil;
}

+ (void) getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock error:(void (^)(NSError *))errorBlock {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/configurationvariables", appID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *configurationVariables = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  [configurationVariables addObject:[AHConfigurationVariable populateWithDictionary:value]];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([configurationVariables copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (errorBlock) {
						 errorBlock(localError);
					 }
				 }
	 ];
}

+ (AHConfigurationVariable *) getByUrl:(NSString *)url error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:url] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHConfigurationVariable populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getByUrl:(NSString *)url usingCallback:(void (^)(AHConfigurationVariable *))configurationVariable errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:url] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (configurationVariable) {
					  configurationVariable([AHConfigurationVariable populateWithDictionary:returnedResults]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

- (BOOL) createWithAppID:(NSString *)appID error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/configurationvariables", appID];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"key\":\"%@\",", self.key];
	[json appendFormat:@"\"value\" : \"%@\"", self.value];
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

- (void) createWithAppID:(NSString *)appID usingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/configurationvariables", appID];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"key\":\"%@\",", self.key];
	[json appendFormat:@"\"value\" : \"%@\"", self.value];
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

- (BOOL) update:(NSError *__autoreleasing *)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"key\":\"%@\",", self.key];
	[json appendFormat:@"\"value\" : \"%@\"", self.value];
	[json appendString:@"}"];
	
	[request putWebRequest:[NSURL URLWithString:self.url] 
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
	
	NSMutableString *json = [NSMutableString stringWithString:@"{"];
	[json appendFormat:@"\"key\":\"%@\",", self.key];
	[json appendFormat:@"\"value\" : \"%@\"", self.value];
	[json appendString:@"}"];
	
	[request putWebRequest:[NSURL URLWithString:self.url] 
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
	
	[request deleteWebRequest:[NSURL URLWithString:self.url] 
			  withContentType:WebRequestContentTypeJson 
					withError:&*error];
	
	if (*error) {
		return NO;
	}
	
	return YES;
}

- (void) deleteUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request deleteWebRequest:[NSURL URLWithString:self.url] 
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

+ (AHConfigurationVariable *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHConfigurationVariable alloc] initWithDictionary:dict];
}

- (AHConfigurationVariable *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	
	self.key = [dict objectForKey:@"key"];
	self.value = [dict objectForKey:@"value"];
	self.url = [dict objectForKey:@"url"];
	
	return self;
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHConfigurationVariable alloc] init];
	
	if (self != nil) {
		self.key = [coder decodeObjectForKey:@"key"];
		self.value = [coder decodeObjectForKey:@"value"];
		self.url = [coder decodeObjectForKey:@"url"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:key forKey:@"key"];
	[coder encodeObject:value forKey:@"value"];
	[coder encodeObject:url forKey:@"url"];
}


@end
