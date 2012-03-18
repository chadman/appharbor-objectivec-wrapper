

#import <Foundation/Foundation.h>


/* Enum that informs the search methods what to include in the search parameters */
typedef enum {
	WebRequestContentTypeXml, // The content type of the request is xml
	WebRequestContentTypeJson, // The content type of the request is json
} WebRequestContentType;

@interface WebRequest : NSObject {

	NSURL *requestURL;
	NSURLResponse *response;
	NSURLConnection *connection;
	NSMutableData *responseData;
	NSError *requestError;
	WebRequestContentType webRequestContentTyp;
}

@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSError *requestError;
@property (nonatomic, assign) WebRequestContentType webRequestContentType;
@property(copy) void (^storedBlock)(id);
@property (copy) void (^webRequestErrorBlock)(NSError*);

- (id) makeWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withError:(NSError **)error;

- (void) makeWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType usingCallback:(void (^)(id))callBackBlock errorBlock:(void (^)(NSError *))errorBlock;

- (id) putWebRequest:(NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData:(NSData *)data withError:(NSError **)error;

- (void) putWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData: (NSData *)data usingCallback:(void (^)(id))returnedResults errorBlock:(void (^)(NSError *))error;

- (id) postWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData: (NSData *)data withError:(NSError **)error;

- (void) postWebRequest: (NSURL *)theUrl withContentType: (WebRequestContentType)contentType withData: (NSData *)data usingCallback:(void (^)(id))returnedResults errorBlock:(void (^)(NSError *))error;

@end

