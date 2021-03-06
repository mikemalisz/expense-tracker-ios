//
//  ETLoginViewController.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/14/21.
//

#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "ETAuthenticationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETLoginViewController : UIViewController <ASAuthorizationControllerPresentationContextProviding>

@property ETAuthenticationManager *_Null_unspecified authenticationManager;

@end

NS_ASSUME_NONNULL_END
