//
//  ETAuthenticationManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETAuthenticationManager.h"

NSString *const ETAuthenticationService = @"authentication";
NSString *const ETUserAccount = @"userAccount";

@interface ETAuthenticationManager ()

@property ETKeychainItem *identityTokenKeychain;

@end


@implementation ETAuthenticationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _identityTokenKeychain = [[ETKeychainItem alloc] initWithServiceString:ETAuthenticationService accountString:ETUserAccount];
    }
    return self;
}

#pragma mark - Authorization Controller Delegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    NSLog(@"%@", authorization.provider);
    id credential = [authorization credential];
    
    if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        [self persistAppleIDCredentialToKeychain:credential];
    } else if ([credential isKindOfClass:[ASPasswordCredential class]]) {
        NSLog(@"ASPasswordCredential: %@", credential);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    #warning handle error
    NSLog(@"%@", error);
}

#pragma mark - Convenience

- (void)persistAppleIDCredentialToKeychain:(ASAuthorizationAppleIDCredential *)credential {
    // create a dictionary containing the user's account details
    NSMutableDictionary *valuesToPersist = [NSMutableDictionary new];
    [valuesToPersist setObject:[credential user] forKey:@"userId"];
    if ([credential email]) {
        [valuesToPersist setObject:[credential email] forKey:@"email"];
    }
    if ([credential identityToken]) {
        NSString *decodedToken = [[NSString alloc] initWithData:[credential identityToken] encoding:NSUTF8StringEncoding];
        if (decodedToken) {
            [valuesToPersist setObject:decodedToken forKey:@"identityToken"];
        }
    }
    
    // serialize and persist the dictionry as a keychain item
    
    NSError *error;
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:[valuesToPersist copy] options:0 error:&error];
    if (serializedData == nil) {
        #warning handle error
        return NSLog(@"%@", error);
    }
    
    BOOL isSuccessful = [[self identityTokenKeychain] setItemValueWithItemData:serializedData error:&error];
    if (!isSuccessful) {
        #warning handle error
        NSLog(@"Couldn't set identityTokenKeychain: %@", error);
    }
}

@end
