

@interface AHUserDefaults : NSObject

+ (AHUserDefaults *) sharedDefaults;

- (void) setClientID: (NSString *) cID;

- (NSString *) clientID;

- (void) setClientSecret: (NSString *) secret;

- (NSString *) clientSecret;

- (NSString *) accessToken;

- (void) setAccessToken: (NSString *)token;

@end
