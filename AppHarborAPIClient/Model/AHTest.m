//
//  AHTest.m
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHTest.h"
#import "WebRequest.h"
#import "AHUserDefaults.h"
#import "Utility.h"

@interface AHTest(PRIVATE)

- (AHTest *)initWithDictionary: (NSDictionary *)dict;

@end

@implementation AHTest
@synthesize testID;
@synthesize name;
@synthesize status;
@synthesize kind;
@synthesize duration;
@synthesize tests;


#pragma mark - Data Methods

+ (NSArray *)getAllByUrl:(NSString *)theUrl error:(NSError **)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:theUrl] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *tests = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[tests addObject:[AHTest populateWithDictionary:value]];
		}
		
		return [tests copy];
	}
	
	return nil;
}

+ (void)getAllByUrl: (NSString *)theUrl usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	
	[request makeWebRequest:[NSURL URLWithString:theUrl] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *tests = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  [tests addObject:[AHTest populateWithDictionary:value]];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([tests copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

+ (NSArray *)getAllByAppID:(NSString *)appID withBuild:(NSInteger)buildID error:(NSError **)error {
	
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/builds/%d/tests", appID, buildID];
	
	NSArray *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
							   withContentType:WebRequestContentTypeJson 
									 withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *tests = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in results) {
			[tests addObject:[AHTest populateWithDictionary:value]];
		}
		
		return [tests copy];
	}
	
	return nil;
}

+ (void)getAllByAppID:(NSString *)appID withBuild:(NSInteger)buildID usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/builds/%d/tests", appID, buildID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *tests = [[NSMutableArray alloc] initWithObjects:nil];
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in returnedResults) {
						  [tests addObject:[AHTest populateWithDictionary:value]];
					  }
				  }
				  
				  // In case they are stupid enough to not create a results block
				  if (resultsBlock) {
					  resultsBlock([tests copy]);
				  }
			  }
				 errorBlock:^(NSError *localError) {
					 
					 if (error) {
						 error(localError);
					 }
				 }
	 ];
}

+ (AHTest *)getByAppID:(NSString *)appID withBuild:(NSInteger)buildID withTestID: (NSString *)tID error:(NSError **)error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/builds/%d/tests/%@", appID, buildID, tID];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:urlString] 
									withContentType:WebRequestContentTypeJson 
										  withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		return [AHTest populateWithDictionary:results];
	}
	
	return nil;
}

+ (void)getByAppID:(NSString *)appID withBuild:(NSInteger)buildID withTestID: (NSString *)tID usingCallback:(void (^)(AHTest *))returnTest errorBlock:(void (^)(NSError *))error {
	
	AHWebRequest *request = [[AHWebRequest alloc] init];
	NSString *urlString = [NSString stringWithFormat:@"https://appharbor.com/applications/%@/builds/%d/tests/%@", appID, buildID, tID];
	
	[request makeWebRequest:[NSURL URLWithString:urlString] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  if (returnTest) {
					  returnTest([AHTest populateWithDictionary:returnedResults]);
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

+ (AHTest *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHTest alloc] initWithDictionary:dict];
}

- (AHTest *)initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	
	self.testID = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
	self.kind = [[dict objectForKey:@"kind"] isEqualToString:@"Group"] ? AHTestKindGroup : AHTestKindTest;
	self.duration = [dict objectForKey:@"duration"];
	
	if ([[dict objectForKey:@"status"] isEqualToString:@"Failed"]) {
		self.status = AHTestStatusFailed;
	}
	else if ([[dict objectForKey:@"status"] isEqualToString:@"Passed"]) {
		self.status = AHTestStatusPassed;
	}
	else if ([[dict objectForKey:@"status"] isEqualToString:@"Skipped"]) {
		self.status = AHTestStatusSkipped;
	}
		  
	if ([[dict objectForKey:@"tests"] count] > 0) {
		
		NSMutableArray *testArray = [[NSMutableArray alloc] initWithObjects:nil];
		
		for (NSDictionary *currentTest in [dict objectForKey:@"tests"]) {
			[testArray addObject:[AHTest populateWithDictionary:currentTest]];
		}
		
		self.tests = [testArray copy];
		
	}
	
	return self;
}


#pragma mark - NSCoding Methods

- (id) initWithCoder: (NSCoder *)coder {
	
	self = [[AHTest alloc] init];
	
	if (self != nil) {
		
		self.testID = [coder decodeObjectForKey:@"testID"];
		self.name = [coder decodeObjectForKey:@"name"];
		self.status = [coder decodeIntForKey:@"status"];
		self.kind = [coder decodeIntForKey:@"kind"];
		self.tests = [coder decodeObjectForKey:@"tests"];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
	
	[coder encodeObject:testID forKey:@"testID"];
	[coder encodeObject:name forKey:@"name"];
	[coder encodeInt:status forKey:@"status"];
	[coder encodeInt:kind forKey:@"kind"];
	[coder encodeObject:tests forKey:@"tests"];
}


@end
