//
//  AppHarborAPIClient.m
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppHarborAPIClient.h"
#import "AHUserDefaults.h"

@implementation AppHarborAPIClient

+ (void) setClientID: (NSString *)key withSecrect: (NSString *)secret {
	[[AHUserDefaults sharedDefaults] setClientID:key];
	[[AHUserDefaults sharedDefaults] setClientSecret:secret];
}


+ (void) setAccessToken: (NSString *)token {
	[[AHUserDefaults sharedDefaults] setAccessToken:token];
}

@end
