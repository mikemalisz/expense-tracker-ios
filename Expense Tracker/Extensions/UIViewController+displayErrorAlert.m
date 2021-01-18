//
//  UIViewController+displayErrorAlert.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "UIViewController+displayErrorAlert.h"

@implementation UIViewController (displayErrorAlert)
- (void)displayErrorAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"An error has occurred"
                                message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
