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
	
	
	WebRequest *request = [[WebRequest alloc] init];
	NSString *stringURL = [NSString stringWithFormat:@"https://appharbor.com/application?access_token=%@", [[AHUserDefaults sharedDefaults] accessToken]];
	
	NSDictionary *results = [request makeWebRequest:[NSURL URLWithString:stringURL] 
									 withContentType:WebRequestContentTypeJson 
										   withError:&*error];
	
	if (*error) {
		return nil;
	}
	
	if (results && ![results isEqual:[NSNull null]]) {
		
		NSMutableArray *applications = [[NSMutableArray alloc] initWithObjects:nil];
		
		// Go through each one and add to the applications to an array
		for (NSDictionary *value in [results objectForKey:@"application"]) {
			[applications addObject:[AHApplication populateWithDictionary:value]];
		}
		
		return [applications copy];
	}
	
	return nil;
	
}

+ (void)getAllUsingCallback:(void (^)(NSArray *))resultsBlock error:(void (^)(NSError *))errorBlock {
	
	
	WebRequest *request = [[WebRequest alloc] init];
	NSString *stringURL = [NSString stringWithFormat:@"https://appharbor.com/application?access_token=", [[AHUserDefaults sharedDefaults] accessToken]];
	
	
	[request makeWebRequest:[NSURL URLWithString:stringURL] 
			withContentType:WebRequestContentTypeJson 
			  usingCallback:^(id returnedResults) {
				  
				  NSMutableArray *applications = [[NSMutableArray alloc] initWithObjects:nil];
				  NSDictionary *applicationResults = nil;
				  
				  if (returnedResults && ![returnedResults isEqual:[NSNull null]]) {
					  
					  if ([returnedResults isKindOfClass:[NSDictionary class]]) {
						  applicationResults = [((NSDictionary *)returnedResults) objectForKey:@"applications"];
					  }
					  
					  // Go through each one and add to the applications to an array
					  for (NSDictionary *value in [applicationResults objectForKey:@"application"]) {
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


#pragma mark - Population Methods

+ (AHApplication *)populateWithDictionary:(NSDictionary *)dict {
	return [[AHApplication alloc] initWithDictionary:dict];
}

- (AHApplication *)initWithDictionary:(NSDictionary *)dict {
	if (![super init]) {
		return nil;
	}

	self.name = [dict objectForKey:@"@name"];
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
