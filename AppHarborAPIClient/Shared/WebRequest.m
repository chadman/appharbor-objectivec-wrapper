
#import "WebRequest.h"
#import "AHUserDefaults.h"
#import "JSON.h"
#import "NRXMLParser.h"

@interface WebRequest (PRIVATE)

- (NSString *) createContentType:(WebRequestContentType)type;
- (NSMutableURLRequest *) createURLRequest:(NSURL *)url;

@end


@implementation WebRequest

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
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	responseData = [NSMutableData data];
}

- (id) postWebRequest:(NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData:(NSData *)data withError:(NSError **)error {

	NSError *localError = nil;
	NSURLResponse *localResponse = nil;
	self.webRequestContentType = contentType;
    
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
	
	responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
                                                          returningResponse:&localResponse
                                                                      error:&localError];
	
	if (localError) {
        NSLog(@"Error occurred :: %@", localError);
    }
    else {
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Web Request Response :: %@", responseBody);
		
		// Create new SBJSON parser object   
		return [responseBody JSONValue];
    }
    
    return localError;
}

- (void) postWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData: (NSData *)data usingCallback:(void (^)(id))returnedResults errorBlock:(void (^)(NSError *))error {
    
    self.storedBlock = returnedResults;
    self.webRequestErrorBlock = error;
	self.webRequestContentType = contentType;
	
    // Create the request 
	NSMutableURLRequest *request = [self createURLRequest:theUrl];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	responseData = [NSMutableData data];
}

- (id) makeWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withError:(NSError **)error {

	NSURLResponse *localResponse = nil;
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
        NSLog(@"Web Request Response :: %@", responseBody);
		
		switch (contentType) {
			case WebRequestContentTypeXml:
				return [NRXMLParser dictionaryForXMLString:responseBody error:&*error];
			case WebRequestContentTypeJson:
				return [responseBody JSONValue];
			default:
				break;
		}
    }
	
	return nil;
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
		
		self.storedBlock(statusError);
    }
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)webError {
    self.storedBlock(webError);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
	
	NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Web Request Response :: %@", responseBody);
	NSError *connectionError = nil;
	NSDictionary *storedBlockResults = nil;
    
	switch (self.webRequestContentType) {
		case WebRequestContentTypeXml:
			
			storedBlockResults = [NRXMLParser dictionaryForXMLString:responseBody error:&connectionError];
			
			if (connectionError) {
				self.webRequestErrorBlock(connectionError);
			}
			else {
				self.storedBlock(storedBlockResults);
			}
			break;
		case WebRequestContentTypeJson:
			self.storedBlock([responseBody JSONValue]);
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
	 [request setValue:[self createContentType:[self webRequestContentType]] forHTTPHeaderField:@"Content-Type"]; 
	 
	 return request;
 }
	 
@end
