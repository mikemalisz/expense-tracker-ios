//
//  ETExpenseOverviewTableViewController.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <UIKit/UIKit.h>
#import "ETExpenseOverviewDataSource.h"
#import "ETServerAPI.h"
#import "ETExpenseItemManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseOverviewTableViewController : UITableViewController
@property ETExpenseItemManager *itemManager;
@end

NS_ASSUME_NONNULL_END
