//
//  ETExpenseItemTableViewCell.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import <UIKit/UIKit.h>
#import "ETExpenseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseItemTableViewCell : UITableViewCell
- (void)updateCellUsingExpenseItem:(ETExpenseItem *)expenseItem;
@end

NS_ASSUME_NONNULL_END
