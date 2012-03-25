//
//  AHBuild.h
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AHBuild : NSObject <NSCoding>

@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *deployed;
@property (strong, nonatomic) NSString *commitID;
@property (strong, nonatomic) NSString *commitMessage;
@property (strong, nonatomic) NSString *downloadUrl;
@property (strong, nonatomic) NSString *testsUrl;
@property (strong, nonatomic) NSString *url;


+ (AHBuild *) populateWithDictionary: (NSDictionary *)dict;



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
+ (AHBuild *)getByUrl:(NSString *)url error:(NSError **)error;


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
+ (void)getByUrl:(NSString *)url usingCallback:(void (^)(AHBuild *))build errorBlock:(void (^)(NSError *))error;


@end
