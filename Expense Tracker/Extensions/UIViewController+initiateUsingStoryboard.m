//
//  UIViewController+initiateUsingStoryboard.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "UIViewController+initiateUsingStoryboard.h"

@implementation UIViewController (initiateUsingStoryboard)
+ (instancetype) initiateUsingStoryboard {
    NSString *className = NSStringFromClass([self class]);
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:className];
}
@end
