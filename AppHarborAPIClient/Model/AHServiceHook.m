

#import "AHServiceHook.h"
#import "WebRequest.h"
#import "AHUserDefaults.h"
#import "Utility.h"

@interface AHServiceHook (PRIVATE)

- (AHServiceHook *)initWithDictionary: (NSDictionary *)dict;

+ (BOOL) validateUrl: (NSString *) candidate;

@end


@implementation AHServiceHook
@synthesize applicationID;
@synthesize value;
@synthesize url;


#pragma mark - Data Methods

+ (NSArray *)getAllByAppID:(NSString *)appID error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/servicehooks", appID];
	
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
			AHServiceHook *currentServiceHook = [AHServiceHook populateWithDictionary:value];
			[currentServiceHook setApplicationID:appID];
			[hostnames addObject:currentServiceHook];
		}
		
		return [hostnames copy];
	}
	
	return nil;
}

+ (void) getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock error:(void (^)(NSError *))errorBlock {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/servicehooks", appID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *servicehooks = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  AHServiceHook *currentServiceHook = [AHServiceHook populateWithDictionary:value];
						  [currentServiceHook setApplicationID:appID];
						  [servicehooks addObject:currentServiceHook];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([servicehooks copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (errorBlock) {
						 errorBlock(localError);
					 }
				 }
	 ];
	
}

+ (AHServiceHook *)getByUrl:(NSString *)url error:(NSError *__autoreleasing *)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:url] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHServiceHook populateWithDictionary:results];
	}
	
	return nil;
}

+ (void) getByUrl:(NSString *)url usingCallback:(void (^)(AHServiceHook *))servicehook errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:url] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (servicehook) {
					  servicehook([AHServiceHook populateWithDictionary:returnedResults]);
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
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/servicehooks", self.applicationID];
	
	if ([AHServiceHook validateUrl:self.value]) {
	
		NSMutableString *json = [NSMutableString stringWithString:@"{"];
		[json appendFormat:@"\"url\":\"%@\"", self.value];
		[json appendString:@"}"];
		
		NSString *location = [request postWebRequest:[NSURL URLWithString:urlString] 
									 withContentType:WebRequestContentTypeJson 
											withData:[json dataUsingEncoding:NSUTF8StringEncoding] 
										   withError:&*error];
		
		if (*error) {
			return NO;
		}
		else {
			[self setUrl:location];
			return YES;
		}
	}
	else {
		
		// Make and return custom domain error.
		NSArray *objArray = [NSArray arrayWithObjects:@"the value must be an absolute url", nil];
		NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
		NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
														  forKeys:keyArray];
		
		*error = [[NSError alloc] initWithDomain:@"com.52projects.appharborapiclient" code:400 userInfo:eDict];
		
		return NO;
	}
}

- (void) createUsingCallback:(void (^)(NSString *))location errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/servicehooks", self.applicationID];
	[self setValue:[self.value lowercaseString]];
	
	if ([AHServiceHook validateUrl:self.value]) {
	
		NSMutableString *json = [NSMutableString stringWithString:@"{"];
		[json appendFormat:@"\"url\":\"%@\"", self.value];
		[json appendString:@"}"];
		
		[request postWebRequest:[NSURL URLWithString:urlString] 
				withContentType:WebRequestContentTypeJson 
					   withData:[json dataUsingEncoding:NSUTF8StringEncoding]  
				  usingCallback:^(id returnLocation) {
					  
					  location(returnLocation);
				  }
					 errorBlock:^(NSError *localError) {
						 
						 if (error) {
							 error(localError);
						 }
					 }
		 ];
	}
	else {
		
		// Make and return custom domain error.
		NSArray *objArray = [NSArray arrayWithObjects:@"the value must be an absolute url", nil];
		NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
		NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
														  forKeys:keyArray];
		
		NSError *urlError = [[NSError alloc] initWithDomain:@"com.52projects.appharborapiclient" code:400 userInfo:eDict];
		error(urlError);
	}
	
	
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

+ (AHServiceHook *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHServiceHook alloc] initWithDictionary:dict];
}

- (AHServiceHook *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	
	self.url = [dict objectForKey:@"url"];
	self.value = [dict objectForKey:@"value"];
	
	return self;
}

+ (BOOL) validateUrl: (NSString *) candidate {
	
	
	NSURL *candidateURL = [NSURL URLWithString:candidate];
	// WARNING > "test" is an URL according to RFCs, being just a path
	// so you still should check scheme and all other NSURL attributes you need
	if (candidateURL && candidateURL.scheme && candidateURL.host) {
		return YES;
	}
	else {
		return NO;
	}
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHServiceHook alloc] init];
	
	if (self != nil) {
		self.value = [coder decodeObjectForKey:@"value"];
		self.url = [coder decodeObjectForKey:@"url"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:value forKey:@"value"];
	[coder encodeObject:url forKey:@"url"];
}


@end
