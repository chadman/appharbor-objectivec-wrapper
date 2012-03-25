//
//  NSObject+serializeToJSON.h
//  AppHarborAPIClient
//
//  Created by Chad Meyer on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (serializeToJSON)

// Serializes an object to xml
- (NSString *)serializeToJSON;

// Serializes an object to xml specifying the parent class name
- (NSString *)serializeToJSON: (NSString *)className isChild:(BOOL)child;

@end