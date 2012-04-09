
#import "WebRequest.h"
#import "AHUserDefaults.h"
#import "AHXMLParser.h"
#import "JSON.h"

@interface AHWebRequest (PRIVATE)

- (NSString *) createContentType:(WebRequestContentType)type;
- (NSMutableURLRequest *) createURLRequest:(NSURL *)url;

@end


@implementation AHWebRequest

@synthesize requestURL;
@synthesize responseData;
@synthesize requestError;
@synthesize storedBlock;
@synthesize webRequestErrorBlock;
@synthesize webRequestContentType;


- (void) makeWebRequest: (NSURL *) theUrl withContentType: (WebRequestContentType)contentType usingCallback:(void (^)(id))callBackBlock errorBlock:(void (^)(NSError *))errorBlock {

    self.storedBlock = callBackBlock;
	self.webRequestErrorBlock = errorBlock;
	self.webRequestContentType = contentType;
	
	// Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	responseData = [NSMutableData data];
}

- (id) putWebRequest:(NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData:(NSData *)data withError:(NSError **)error {
	
	NSURLResponse *localResponse = nil;
	self.webRequestContentType = contentType;
    
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	[request setValue:[self createContentType:[self webRequestContentType]] forHTTPHeaderField:@"Content-Type"]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
	
	responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
														  returningResponse:&localResponse
																	  error:&*error];
	if (*error) {
        NSLog(@"Error occurred :: %@", *error);
		return nil;
    }
    else {
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Web Request Response :: %@", responseBody);
		
		// Create new SBJSON parser object   
		return [responseBody JSONValue];
    }
}


- (void) putWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData: (NSData *)data usingCallback:(void (^)(id))returnedResults errorBlock:(void (^)(NSError *))error {

    self.storedBlock = returnedResults;
	self.webRequestErrorBlock = error;
	self.webRequestContentType = contentType;
    
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];	
	[request setValue:[self createContentType:[self webRequestContentType]] forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	responseData = [NSMutableData data];
}

- (id) postWebRequest:(NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData:(NSData *)data withError:(NSError **)error {

	NSError *localError = nil;
	NSHTTPURLResponse *localResponse = nil;
	self.webRequestContentType = contentType;
    
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	[request setValue:[self createContentType:[self webRequestContentType]] forHTTPHeaderField:@"Content-Type"]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
	
	responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
                                                          returningResponse:&localResponse
                                                                      error:&localError];
	
	if (localError) {
        NSLog(@"Error occurred :: %@", localError);
		*error = localError;
    }
    else {
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSInteger statusCode = [localResponse statusCode];
		NSLog(@"Web Request Response :: %@", responseBody);
		
		if (statusCode == 201) {
			return [[localResponse allHeaderFields] objectForKey:@"Location"];
		}
		else {
			*error = [NSError errorWithDomain:@"com.52projects.appharborAPI" code:statusCode userInfo:nil];
		}
    }
    
    return nil;
}

- (void) postWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData: (NSData *)data usingCallback:(void (^)(id))returnedResults errorBlock:(void (^)(NSError *))error {
    
    self.storedBlock = returnedResults;
    self.webRequestErrorBlock = error;
	self.webRequestContentType = contentType;
	
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	[request setValue:[self createContentType:[self webRequestContentType]] forHTTPHeaderField:@"Content-Type"]; 
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	responseData = [NSMutableData data];
}

- (id) makeWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withError:(NSError **)error {

	NSHTTPURLResponse *localResponse = nil;
	self.webRequestContentType = contentType;
    
	// Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setHTTPMethod:@"GET"];
	responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&localResponse
                                                     error:&*error];
	if (*error) {
        NSLog(@"Error occurred :: %@", *error);
		return nil;
    }
    else {
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		NSInteger statusCode = [localResponse statusCode];
        NSLog(@"Web Request Response :: %@", responseBody);
		
		switch (contentType) {
			case WebRequestContentTypeXml:
				return [AHXMLParser dictionaryForXMLString:responseBody error:&*error];
			case WebRequestContentTypeJson:
				if (statusCode < 300) {
					return [(NSString *)responseBody JSONValue];
				}
			default:
				break;
		}
    }
	
	return nil;
}

- (BOOL) deleteWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withError:(NSError **)error {
	
	NSHTTPURLResponse *localResponse = nil;
	self.webRequestContentType = contentType;
    
	// Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setHTTPMethod:@"DELETE"];
	responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
														  returningResponse:&localResponse
																	  error:&*error];
	if (*error) {
        NSLog(@"Error occurred :: %@", *error);
		return NO;
    }
    else {
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		NSInteger statusCode = [localResponse statusCode];
        NSLog(@"Web Request Response :: %@", responseBody);
		
		if (statusCode < 300) {
			return YES;
		}
		else {
			*error = [NSError errorWithDomain:@"com.52projects.appharborAPI" code:statusCode userInfo:nil];
			return NO;
		}
    }

}

- (void) deleteWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType usingCallback:(void (^)(id))returnedResults errorBlock:(void (^)(NSError *))error {
	
	self.storedBlock = returnedResults;
    self.webRequestErrorBlock = error;
	self.webRequestContentType = contentType;
	
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
    [request setHTTPMethod:@"DELETE"];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	responseData = [NSMutableData data];
	
}



#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse {
	response = aResponse;
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
	[responseData appendData:data];
	
	int statusCode = [((NSHTTPURLResponse *)response) statusCode];
   
	if (statusCode >= 400) {
			[connection cancel];  // stop connecting; no more delegate messages
			NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
											  NSLocalizedString(@"Server returned status code %d",@""),
											  statusCode]
									  forKey:NSLocalizedDescriptionKey];
        NSError *statusError = [NSError errorWithDomain:@"dontknow"
							  code:statusCode
						  userInfo:errorInfo];
		
		self.webRequestErrorBlock(statusError);
    }
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)webError {
    self.webRequestErrorBlock(webError);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
	
	NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Web Request Response :: %@", responseBody);
	int statusCode = [((NSHTTPURLResponse *)response) statusCode];
	NSError *connectionError = nil;
	NSDictionary *storedBlockResults = nil;
	
	switch (self.webRequestContentType) {
		case WebRequestContentTypeXml:
			
			storedBlockResults = [AHXMLParser dictionaryForXMLString:responseBody error:&connectionError];
			
			if (connectionError) {
				self.webRequestErrorBlock(connectionError);
			}
			else {
				self.storedBlock(storedBlockResults);
			}
			break;
		case WebRequestContentTypeJson:
			if (statusCode < 300) {
				
				if(statusCode == 201) {
					
					NSString *location = [[((NSHTTPURLResponse *)response) allHeaderFields] objectForKey:@"Location"];
					self.storedBlock(location);
				}
				
				else if (statusCode != 204) {
					self.storedBlock([responseBody JSONValue]);
				}
				else {
					self.storedBlock(responseBody);
				}
			}
			else {
				self.webRequestErrorBlock([NSError errorWithDomain:@"com.52projects.appharborAPI" code:statusCode userInfo:nil]);
			}
		default:
			break;
	}
    
}


#pragma mark Private Methods

- (NSString *) createContentType:(WebRequestContentType)type {
	
	switch (type) {
		case WebRequestContentTypeXml:
			return @"application/xml";
		case WebRequestContentTypeJson:
			return @"application/json";
	}
	
	return nil;
}

 - (NSMutableURLRequest *) createURLRequest:(NSURL *)url {
	 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];	
	 [request setValue:[self createContentType:[self webRequestContentType]] forHTTPHeaderField:@"Accept"]; 
	 [request setValue:[NSString stringWithFormat: @"BEARER %@", [[AHUserDefaults sharedDefaults] accessToken]] forHTTPHeaderField:@"Authorization"];
	 
	 return request;
 }
	 
@end
