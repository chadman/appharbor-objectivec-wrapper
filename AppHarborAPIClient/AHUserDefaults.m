//
//  AHUserDefaults.m
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHUserDefaults.h"

@implementation AHUserDefaults


static AHUserDefaults *_sharedDefaults = nil;

+ (AHUserDefaults *) sharedDefaults {
	return _sharedDefaults;
}

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        _sharedDefaults = [[AHUserDefaults alloc] init];
    }
}


- (NSString *)clientID {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kAppHarborClientID];
}

- (void) setClientID:(NSString *)cID {
	
	[[NSUserDefaults standardUserDefaults] setObject:cID forKey:kAppHarborClientID];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *) clientSecret {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kAppHarborClientSecret];
}

- (void) setClientSecret:(NSString *)secret {
	
	[[NSUserDefaults standardUserDefaults] setObject:secret forKey:kAppHarborClientSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) accessToken {
	
return [[NSUserDefaults standardUserDefaults] objectForKey:kAppHarborAccessToken];
	
}

- (void) setAccessToken: (NSString *)token {
	
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:kAppHarborAccessToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) killAll {
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppHarborClientID];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppHarborClientSecret];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppHarborAccessToken];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppHarborRefreshToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
