//
//  ETAuthenticationManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETAuthenticationManager.h"
#import "ETServerProvider.h"

NSString *const ETAuthenticationService = @"authentication";
NSString *const ETUserAccount = @"userAccount";

@interface ETAuthenticationManager ()

@property ETKeychainItem *identityTokenKeychain;

@property id <ETAuthenticationServer> server;

@end


@implementation ETAuthenticationManager

- (instancetype)initWithAuthenticationServer:(id<ETAuthenticationServer>)server {
    self = [super init];
    if (self) {
        _identityTokenKeychain = [[ETKeychainItem alloc] initWithServiceString:ETAuthenticationService accountString:ETUserAccount];
        _server = server;
        _authenticationState = ETAuthenticationLoading;
        
        [self checkAuthenticationStatus];
    }
    return self;
}

#pragma mark - Authentication Status

- (void)checkAuthenticationStatus {
    [self setAuthenticationState:ETAuthenticationLoading];
    
    [[self server] requestAuthenticationStatusWithCompletionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            #warning handle error
        } else if (data != nil) {
            // determine authentication state from returned data
            NSNumber *isAuthenticated = [data objectForKey:@"isAuthenticated"];
            if ([isAuthenticated boolValue]) {
                [self setAuthenticationState:ETAuthenticated];
            } else {
                [self setAuthenticationState:ETUnauthenticated];
            }
        }
    }];
}

#pragma mark - Authorization Controller Delegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    
    NSLog(@"%@", authorization.provider);
    id credential = [authorization credential];
    
    if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        [self handleServerAuthenticationWithCredential:credential];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    #warning handle error
    NSLog(@"%@", error);
}

#pragma mark - Convenience

- (void)handleServerAuthenticationWithCredential: (ASAuthorizationAppleIDCredential *)credential {
    NSDictionary *data = @{
        @"identityToken": [[NSString alloc] initWithData: [credential identityToken] encoding:NSUTF8StringEncoding],
        @"clientId": [[NSBundle mainBundle] bundleIdentifier]
    };
    
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    if (serializedData != nil) {
        
        [[self server] authenticateWithPostData:serializedData completionHandler:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@, error: %@", response, error);
        }];
    }
}

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
