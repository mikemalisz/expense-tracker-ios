//
//  ETAuthenticationManager.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "ETKeychainItem.h"
#import "ETAuthenticationServer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ETAuthenticationState) {
    ETUnauthenticated = 0,
    ETAuthenticated
};

extern NSString * const ETAuthenticationManagerStateKeyPath;

@interface ETAuthenticationManager : NSObject <ASAuthorizationControllerDelegate>

- (instancetype)initWithAuthenticationServer:(id <ETAuthenticationServer>)server;

- (void)authenticateWithIdentityToken:(NSString *)token bundleId:(NSString *)bundleId;

@property ETAuthenticationState authenticationState;

@property void (^ _Nullable handleErrorAction)(NSError *);

@end

NS_ASSUME_NONNULL_END
