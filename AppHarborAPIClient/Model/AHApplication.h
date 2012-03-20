//
//  AHApplication.h
//  AppHarborAPIClient
//
//  Created by Meyer, Chad on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AHApplication : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *slug;
@property (strong, nonatomic) NSString *url;

@end
