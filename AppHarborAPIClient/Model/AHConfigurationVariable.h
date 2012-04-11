

@interface AHConfigurationVariable : NSObject <NSCoding>


@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *url;


+ (AHConfigurationVariable *) populateWithDictionary: (NSDictionary *)dict;


/*! 
 @method      getAll:
 
 @abstract 
 Performs a synchronous call to the App Harbor API Configuration Variable
 resource. 
 
 @discussion
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 @result      An array of app harbor Application objects or nil if 
 the load failed.
 
 */
+ (NSArray *)getAllByAppID: (NSString *)appID error:(NSError **)error;


/*! 
 @method      getAllUsingCallback:error:
 
 @abstract 
 Performs an asynchronous call to the 
 App Harbor API Applications resource. 
 
 @discussion
 
 @param
 resultsBlock	The block that is performed after the
 request to the app harbor api has happened.
 
 @param
 errorBlock	If the requests errors for any reason, 
 a block is available for that
 
 @result      An array of app harbor Application objects or nil if 
 the load failed.
 
 */
+ (void)getAllByAppID: (NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock error:(void (^)(NSError *))errorBlock;


/*! 
 @method      getBySlug:error:
 
 @abstract 
 Performs an asynchronous call to the 
 App Harbor API Application resource. 
 
 @discussion
 
 @param
 appSlug	The appSlug is a variable that appHarbor uses
 to distinguish between applications. Its usually the app
 name without spaces
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 @result      An AHApplication object that holds the information
 about the application that was retrieved
 
 */
+ (AHConfigurationVariable *)getByUrl:(NSString *)url error:(NSError **)error;


/*! 
 @method      getBySlug:usingCallback:errorBlock:
 
 @abstract 
 Performs an asynchronous call to the 
 App Harbor API Application resource. 
 
 @discussion
 
 @param
 appSlug	The appSlug is a variable that appHarbor uses
 to distinguish between applications. Its usually the app
 name without spaces
 
 @param
 resultsBlock	The block that is performed after the
 request to the app harbor api has happened.
 
 @param
 error	If the requests errors for any reason, 
 a block is available for that
 
 */
+ (void)getByUrl:(NSString *)url usingCallback:(void (^)(AHConfigurationVariable *))configurationVariable errorBlock:(void (^)(NSError *))error;

/*! 
 @method      create:
 
 @abstract 
 Performs a synchronous call to the App Harbor API 
 to create a new application
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (BOOL) createWithAppID:(NSString *)appID error:(NSError **)error;

/*! 
 @method      createUsingCallback:errorBlock
 
 @abstract 
 Performs an asynchronous call to the App Harbor API 
 to create a new application
 
 @param
 isSuccessful	Block that gives a boolean on whether or not
 the operation was successful
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (void)createWithAppID: (NSString *)appID usingCallback:(void (^)(NSString *))location errorBlock:(void (^)(NSError *))error;


/*! 
 @method      update:
 
 @abstract 
 Performs a synchronous call to the App Harbor API 
 to update the existing application
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (BOOL) update: (NSError **)error;

/*! 
 @method      updateUsingCallback:errorBlock
 
 @abstract 
 Performs an asynchronous call to the App Harbor API 
 to update the existing application
 
 @param
 isSuccessful	Block that gives a boolean on whether or not
 the operation was successful
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (void)updateUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error;

/*! 
 @method      delete:
 
 @abstract 
 Performs a synchronous call to the App Harbor API 
 to delete the existing application.
 
 @discussion
 It is highly recommended that when calling this method you 
 give the user a warning on what is about to happen
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (BOOL) delete: (NSError **)error;

/*! 
 @method      deleteUsingCallback:errorBlock
 
 @abstract 
 Performs an asynchronous call to the App Harbor API 
 to delete the existing application.
 
 @discussion
 It is highly recommended that when calling this method you 
 give the user a warning on what is about to happen
 
 @param
 isSuccessful	Block that gives a boolean on whether or not
 the operation was successful
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (void)deleteUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error;

@end
