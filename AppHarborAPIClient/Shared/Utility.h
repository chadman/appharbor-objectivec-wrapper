
@interface Utility : NSObject {

}

+(NSString *)getFTAPIValueFromPList: (NSString *)pListKey;
+(NSString *)getValueFromPList: (NSString *)pListFileName withListKey: (NSString *)pListKey;

// Converts an object to a BOOL
+(BOOL) convertToBOOL:(id) value;

+(int) convertToInt:(id) value;

+(float) convertToFloat: (id) value;

// Convert an object to an NSDate
+(NSDate *) convertToNSDate: (id) value;

// Convert an object to a full date NSDate
+(NSDate *) convertToFullNSDate: (id) value;

+(NSDate *) convertToCustomNSDate: (id) value formatter: (NSString *)format;
@end