//
//  UIViewController+displayErrorAlert.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (displayErrorAlert)
- (void)displayErrorAlertWithMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
