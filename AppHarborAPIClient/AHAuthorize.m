//
//  AppHarborAPIClient.m
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AHAuthorize.h"
#import "AHUserDefaults.h"

@implementation AHAuthorize

+ (BOOL) isUserValid {
	
	NSString *token = [[AHUserDefaults sharedDefaults] accessToken];
	return [token length] > 0;
}

+ (void) authorizeUser:(NSString *)redirectUrl {
	NSMutableString *urlString = [NSMutableString stringWithString: @"https://appharbor.com/user/authorizations/new"];
	[urlString appendFormat:@"?client_id=%@", [[AHUserDefaults sharedDefaults] clientID]];
	[urlString appendFormat:@"&redirect_url=%@", redirectUrl];
	NSURL *url = [NSURL URLWithString:[urlString copy]];
	
	if (![[UIApplication sharedApplication] openURL:url])
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}


+ (void) setClientID: (NSString *)key withSecrect: (NSString *)secret {
	[[AHUserDefaults sharedDefaults] setClientID:key];
	[[AHUserDefaults sharedDefaults] setClientSecret:secret];
}


+ (void) setAccessToken: (NSString *)token {
	[[AHUserDefaults sharedDefaults] setAccessToken:token];
}

+ (BOOL) handleOpenURL: (NSURL *)url error: (NSError **)error {
	
	NSArray *codeComponent = [[NSString stringWithFormat:@"%@", url] componentsSeparatedByString:@"code="];
	NSString *codeString = [codeComponent objectAtIndex:1];

	NSMutableString *httpBody = [NSMutableString stringWithFormat:@"client_id=%@", [[AHUserDefaults sharedDefaults] clientID]];
	[httpBody appendFormat:@"&client_secret=%@", [[AHUserDefaults sharedDefaults] clientSecret]];
	[httpBody appendFormat:@"&code=%@", codeString];
	NSData *myRequestData = [NSData dataWithBytes: [httpBody UTF8String] length: [httpBody length]];
	
	NSURL *accessTokenurl = [NSURL URLWithString:@"https://appharbor.com/tokens"];
	
	NSError *localError = nil;
	NSURLResponse *localResponse = nil;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:accessTokenurl];	
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:myRequestData];
	
	NSMutableData *responseData = nil;
	responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
                                                          returningResponse:&localResponse
                                                                      error:&localError];
	
	if (localError) {
        NSLog(@"Error occurred :: %@", localError);
		return NO;
    }
    else {
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"Web Request Response :: %@", responseBody);
		
		codeComponent = [responseBody componentsSeparatedByString:@"&"];
		NSString *accessToken = [[[codeComponent objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
		[[AHUserDefaults sharedDefaults] setAccessToken:accessToken];
		return YES;
    }

	
}

+ (NSString *) accessToken {
	return [[AHUserDefaults sharedDefaults] accessToken];
}

+ (void) killSettings {
	[[AHUserDefaults sharedDefaults] killAll];
}

@end
