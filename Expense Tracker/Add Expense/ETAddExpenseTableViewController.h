//
//  ETAddExpenseTableViewController.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import <UIKit/UIKit.h>
#import "ETExpenseItemManager.h"
#import "UIViewController+displayErrorAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETAddExpenseTableViewController : UITableViewController <UITextFieldDelegate>

@property ETExpenseItemManager * _Null_unspecified itemManager;

@end

NS_ASSUME_NONNULL_END
