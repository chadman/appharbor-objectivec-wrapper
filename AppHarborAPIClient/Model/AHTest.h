

typedef enum {
	AHTestStatusPassed, // Test status of passed
	AHTestStatusFailed, // Test status of failed
	AHTestStatusSkipped // Test status of skipped
} AHTestStatus;

typedef enum {
	AHTestKindGroup,
	AHTestKindTest
} AHTestKind;

@interface AHTest : NSObject <NSCoding>

@property (strong, nonatomic) NSString *testID;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) AHTestStatus status;
@property (nonatomic) AHTestKind kind;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSArray *tests;


+ (AHTest *) populateWithDictionary: (NSDictionary *)dict;


+ (NSArray *)getAllByUrl:(NSString *)theUrl error:(NSError **)error;


+ (void)getAllByUrl: (NSString *)theUrl usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error;



/*! 
 @method      getAllByAppID:error:
 
 @abstract 
 Performs a synchronous call to the App Harbor API Collaborator
 resource. 
 
 @discussion
 
 @param
 appID	The application slug name that will be used to get 
 the collaborators
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 @result      An array of app harbor Application objects or nil if 
 the load failed.
 
 */
+ (NSArray *)getAllByAppID:(NSString *)appID withBuild:(NSInteger)buildID error:(NSError **)error;


/*! 
 @method      getAllByAppID:usingCallback:error:
 
 @abstract 
 Performs an asynchronous call to the 
 App Harbor API Collaborators resource. 
 
 @discussion
 
 @param
 resultsBlock	The block that is performed after the
 request to the app harbor api has happened.
 
 @param
 error	If the requests errors for any reason, 
 a block is available for that
 
 @result      An array of app harbor Application objects or nil if 
 the load failed.
 
 */
+ (void)getAllByAppID:(NSString *)appID withBuild:(NSInteger)buildID usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error;

/*! 
 @method      getByUserID:forApp:error
 
 @abstract 
 Performs a synchronous call to the 
 App Harbor API Collaborator resource. 
 
 @discussion
 
 @param
 userUrl	the url to the collaborator, we cannot get by id right now
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 @result      An AHApplication object that holds the information
 about the application that was retrieved
 
 */
+ (AHTest *)getByAppID:(NSString *)appID withBuild:(NSInteger)buildID withTestID: (NSString *)tID error:(NSError **)error;


/*! 
 @method      getByUserID:forApp:usingCallback:errorBlock:
 
 @abstract 
 Performs an asynchronous call to the 
 App Harbor API Collaborator resource. 
 
 @discussion
 
 @param
 userUrl	the url to the collaborator, we cannot get by id right now
 
 @param
 resultsBlock	The block that is performed after the
 request to the app harbor api has happened.
 
 @param
 error	If the requests errors for any reason, 
 a block is available for that
 
 */
+ (void)getByAppID:(NSString *)appID withBuild:(NSInteger)buildID withTestID: (NSString *)tID usingCallback:(void (^)(AHTest *))returnTest errorBlock:(void (^)(NSError *))error;




@end
