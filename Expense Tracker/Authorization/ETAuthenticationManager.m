//
//  ETAuthenticationManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETAuthenticationManager.h"

NSString * const ETAuthenticationManagerStateKeyPath = @"authenticationState";

NSString * const ETIsAuthenticatedKey = @"isAuthenticated";

@interface ETAuthenticationManager ()

@property id <ETAuthenticationServer> server;

@end


@implementation ETAuthenticationManager

- (instancetype)initWithAuthenticationServer:(id<ETAuthenticationServer>)server {
    self = [super init];
    if (self) {
        _server = server;
        
        BOOL wasPreviouslyAuthenticated = [NSUserDefaults.standardUserDefaults boolForKey:ETIsAuthenticatedKey];
        
        // set authentication state to the last known authentication state
        _authenticationState = wasPreviouslyAuthenticated ? ETAuthenticated : ETUnauthenticated;
        [self checkAuthenticationStatus];
    }
    return self;
}

#pragma mark - Authentication Status

- (void)checkAuthenticationStatus {
    typeof(self) __weak weakSelf = self;
    [[self server] requestAuthenticationStatusWithCompletionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (weakSelf == nil) { return; }
        
        if (error != nil) {
            weakSelf.handleErrorAction(error);
        } else if (data != nil) {
            // determine authentication state from returned data
            
            NSNumber *isAuthenticated = [data objectForKey:@"isAuthenticated"];
            
            ETAuthenticationState newState = isAuthenticated.boolValue ? ETAuthenticated : ETUnauthenticated;
            
            if (newState != weakSelf.authenticationState) {
                [weakSelf setAuthenticationState:newState];
                [NSUserDefaults.standardUserDefaults setBool:newState forKey:ETIsAuthenticatedKey];
            }
        }
    }];
}

#pragma mark - Authorization Controller Delegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    id credential = [authorization credential];
    
    if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // convert token from data encoding to string
        ASAuthorizationAppleIDCredential *applieIDCredential = credential;
        NSString *token = [[NSString alloc]
                           initWithData:applieIDCredential.identityToken
                           encoding:NSUTF8StringEncoding];
        NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
        
        [self authenticateWithIdentityToken:token bundleId:bundleId];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    self.handleErrorAction(error);
}

#pragma mark - Server Authentication

- (void)authenticateWithIdentityToken:(NSString *)token bundleId:(NSString *)bundleId {
    NSDictionary *data = @{
        @"identityToken": token,
        @"clientId": bundleId
    };
    
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    if (serializedData != nil) {
        
        typeof(self) __weak weakSelf = self;
        [[self server] authenticateWithPostData:serializedData completionHandler:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                weakSelf.handleErrorAction(error);
            } else {
                [weakSelf checkAuthenticationStatus];
            }
        }];
    }
}

@end
