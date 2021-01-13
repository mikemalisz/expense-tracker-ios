//
//  ETExpenseItemTableViewCell.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseItemTableViewCell : UITableViewCell
- (void)setDollarAmountText:(NSString *)text;
- (void)setExpenseItemTitleText:(NSString *)text;
- (void)setDatePurchasedText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
