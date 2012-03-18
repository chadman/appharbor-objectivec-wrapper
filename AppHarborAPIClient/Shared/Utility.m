
#import "Utility.h"
#import "DateUtility.h"

@interface Utility () 

+(NSDictionary *)getPList: (NSString *)pListFileName;

@end


NSString *_apiListFileName		= @"FTAPI.plist";
NSString *_infoListFileName		= @"info.plist";

@implementation Utility

+ (NSString *)getFTAPIValueFromPList: (NSString *)pListKey {
	
	NSDictionary *plistDictionary = [self getPList: _apiListFileName];
	
	if (plistDictionary != nil) {
		return [plistDictionary objectForKey: pListKey];
	}
	else {
		return nil;
	}
	
}

+ (NSString *)getValueFromPList: (NSString *)pListFileName withListKey: (NSString *)pListKey {
	
	NSDictionary *plistDictionary = [self getPList: pListFileName];
	
	if (plistDictionary != nil) {
		return [plistDictionary objectForKey: pListKey];
	}
	else {
		return nil;
	}	
}

+ (NSDictionary *)getPList: (NSString *)pListFileName {
	
	NSDictionary *plistDictionary;
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [path stringByAppendingPathComponent: pListFileName];
	plistDictionary = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	
	return plistDictionary;
}

+(BOOL) convertToBOOL: (id) value {
	
	if (![value isKindOfClass:[NSNull class]]) {
		
		// The value is not null so now to find out if the value is a BOOL
		if ([NSNumber numberWithBool:[value boolValue]]) {
			return [value boolValue];
		}
	}
	
	return NO;
}

+ (float) convertToFloat: (id) value {
	if (![value isKindOfClass:[NSNull class]] && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
		return [value floatValue];
	}
	
	return INT32_MIN;
}

+(int) convertToInt:(id) value {
	
	if (![value isKindOfClass:[NSNull class]] && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
		return [value intValue];
	}
	
	return INT32_MIN;
}

+(NSDate *) convertToNSDate:(id) value {
	
	if ([value isEqual:[NSNull null]]) {
		return nil;
	}
	else {
		return [DateUtility dateFromString:value];
	}
}

+(NSDate *) convertToFullNSDate: (id) value {
	if ([value isEqual:[NSNull null]]) {
		return nil;
	}
	else {
		return [DateUtility dateAndTimeFromString:value];
	}
}


+(NSDate *) convertToCustomNSDate: (id) value formatter: (NSString *)format {
	if ([value isEqual:[NSNull null]]) {
		return nil;
	}
	else {
		return [DateUtility dateFromString:value withDateFormat:format];
	}
}

@end

