//
//  ETAuthenticationNavigationController.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import <UIKit/UIKit.h>
#import "ETAuthenticationManager.h"
#import "ETLoginViewController.h"
#import "ETExpenseOverviewTableViewController.h"
#import "ETServerProvider.h"
#import "ETExpenseItemManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETAuthenticationNavigationController : UINavigationController

@property ETAuthenticationManager * _Null_unspecified authenticationManager;

@end

NS_ASSUME_NONNULL_END
