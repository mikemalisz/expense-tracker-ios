//
//  ETAuthenticationManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETAuthenticationManager.h"

NSString *const ETAuthenticationService = @"authentication";
NSString *const ETIdentityTokenAccount = @"identityToken";

@interface ETAuthenticationManager ()

@property ETKeychainItem *identityTokenKeychain;

@end


@implementation ETAuthenticationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _identityTokenKeychain = [[ETKeychainItem alloc] initWithServiceString:ETAuthenticationService accountString:ETIdentityTokenAccount];
    }
    return self;
}

#pragma mark - Authorization Controller Delegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    NSLog(@"%@", authorization.provider);
    id credential = [authorization credential];
    
    if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = credential;
        
        NSError *error;
        BOOL isSuccessful = [[self identityTokenKeychain] setItemValueWithItemData:[appleIDCredential identityToken] error:&error];
        
        if (!isSuccessful) {
            #warning handle error
            NSLog(@"Couldn't set identityTokenKeychain: %@", error);
        }
        
    } else if ([credential isKindOfClass:[ASPasswordCredential class]]) {
        NSLog(@"ASPasswordCredential: %@", credential);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    #warning handle error
    NSLog(@"%@", error);
}

@end
