//
//  AppHarborAPIClient.h
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHarborAPIClient : NSObject


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
 @method      setAccessToken:
 
 @abstract 
 Sets the access token for all 
 
 @discussion
 
 @param
 key	The client_id that should be supplied by AppHarbor
 Register for a client key at https://appharbor.com/clients/new	
 
 @param
 secret		The client_secret that should be supplied by AppHarbor
 when a client application is registered. Register for a client key
 at https://appharbor.com/clients/new
 
 */
+ (void) setAccessToken: (NSString *)token;

@end
