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

@interface ETAuthenticationManager : NSObject <ASAuthorizationControllerDelegate>

- (instancetype)initWithAuthenticationServer:(id <ETAuthenticationServer>)server;

@end

NS_ASSUME_NONNULL_END
