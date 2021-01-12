//
//  ETExpenseOverviewTableViewController.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <UIKit/UIKit.h>
#import "ETServerAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseOverviewTableViewController : UITableViewController
@property id <ETServerAPI> networkService;
@end

NS_ASSUME_NONNULL_END
