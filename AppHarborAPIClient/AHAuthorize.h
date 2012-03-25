//
//  AppHarborAPIClient.h
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AHAuthorize : NSObject


/*! 
 @method      setClientID:withSecret:
 
 @abstract 
 Sets the client ID and the client secret for the 
 client application. This is performed to provide one
 place to set the required keys for OAuth. Doing it 
 through plists got complicated when unit testing
 
 @discussion
 
 @param
 key	The client_id that should be supplied by AppHarbor
 Register for a client key at https://appharbor.com/clients/new	
 
 @param
 secret		The client_secret that should be supplied by AppHarbor
 when a client application is registered. Register for a client key
 at https://appharbor.com/clients/new
 
 */
+ (void) setClientID: (NSString *)key withSecrect: (NSString *)secret;

/*!
 @method	isUserValid
 
 @abstract
 Call this method to find out if the user
 is valid. This will check the access token on file
 if one exists and also do a small call to the api to make
 sure the access token is valid.
 
 @discussion
 If the access token is invalid or does not exist, you can
 call [AHAuthorize authorizeUser] to get a valid access token
*/
+ (BOOL) isUserValid;


/*! 
 @method      authorizeUser
 
 @abstract 
 Calling this method will make sure the 
 access token on file is still valid. If it is not
 then it will open safari to get the credentials needed
 to get an access token. Please include application:handleOpenURL:
 in your application delegate and call [AHAuthorize handleOpenURL:]
 to handle retrieving an access token.
 
 @discussion
 This method assumes that setClientID:withSecrete: has been called
 
 @param
 redirectUrl	The url to redirect to after the user has been authorized
 This will usually be the application name url. ex: Goharbor is an application
 built using this API, the redirect url for that would be goharbor://
 
 */
+ (void) authorizeUser:(NSString *)redirectUrl;


/*! 
 @method      handleOpenURL:error:
 
 @abstract 
 Call this method from the application:handleOpenURL: in your application delegate
 
 @discussion
 This method assumes that setClientID:withSecrete: has been called
 
 @param
 url	The url returned from the [AHAuthorize authorizeUser] method
 
 */
+ (BOOL) handleOpenURL: (NSURL *)url error: (NSError **)error;


/*! 
 @method      setAccessToken:
 
 @abstract 
 Sets the access token for the app harbor api. This is an option
 in case you do not want to use [AHAuthorize authorizeUser] as a way
 to authorize the user
 
 @discussion
 
 @param
 token	The access token for the user using the application. This is required
 for all subsequent requests to the app harbor API.

 
 */
+ (void) setAccessToken: (NSString *)token;

/*!
 @method	accessToken
 
 @abstract	
 Returns the access token that is currently saved.
*/
+ (NSString *) accessToken;

/*!
 @method	killSettings
 
 @abstract
 Kills all the saved keys including client_id, client_secret and access_token
 
 @discussion
 Use this for when a user does not want to be remembered in the applicationj
 
*/
+ (void) killSettings;

@end
