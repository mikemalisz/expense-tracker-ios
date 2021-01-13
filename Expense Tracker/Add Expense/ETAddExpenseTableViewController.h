//
//  ETAddExpenseTableViewController.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import <UIKit/UIKit.h>
#import "ETExpenseItemManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETAddExpenseTableViewController : UITableViewController
@property ETExpenseItemManager * _Null_unspecified itemManager;
@end

NS_ASSUME_NONNULL_END
