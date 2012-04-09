

typedef enum {
	AHCollaboratorRoleAdministrator, 
	AHCollaboratorRoleCollaborator // Search for a household by a phone number
} AHCollaboratorRole;


@interface AHCollaborator : NSObject <NSCoding>

@property (strong, nonatomic) NSString * userID;
@property (strong, nonatomic) NSString * userName;
@property (nonatomic) AHCollaboratorRole role;
@property (strong, nonatomic) NSString * url;

// Populate this property when adding a new collaborator
// This property is not populated when retrieving collaborators
@property (strong, nonatomic) NSString * collaboratorEmail;

// The name of the application the collaborator will be a part of
@property (strong, nonatomic) NSString * appName;


+ (AHCollaborator *) populateWithDictionary: (NSDictionary *)dict;



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
+ (NSArray *)getAllByAppID:(NSString *)appID error:(NSError **)error;


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
+ (void)getAllByAppID:(NSString *)appID usingCallback:(void (^)(NSArray *))resultsBlock errorBlock:(void (^)(NSError *))error;


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
+ (AHCollaborator *)getByUserUrl:(NSString *)userUrl error:(NSError **)error;


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
+ (void)getByUserUrl:(NSString *)userUrl usingCallback:(void (^)(AHCollaborator *))collaborator errorBlock:(void (^)(NSError *))error;

/*! 
 @method      create:
 
 @abstract 
 Performs a synchronous call to the App Harbor API 
 to create a new collaborator
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (BOOL) create: (NSError **)error;

/*! 
 @method      createUsingCallback:errorBlock
 
 @abstract 
 Performs an asynchronous call to the App Harbor API 
 to create a new collaborator
 
 @param
 isSuccessful	Block that gives a boolean on whether or not
 the operation was successful
 
 @param
 error     Out parameter (may be NULL) used if an error occurs
 while processing the request. Will not be modified if the 
 load succeeds.
 
 */
- (void)createUsingCallback:(void (^)(BOOL))isSuccessful errorBlock:(void (^)(NSError *))error;






@end
