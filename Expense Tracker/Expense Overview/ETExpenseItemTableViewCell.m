//
//  ETExpenseItemTableViewCell.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "ETExpenseItemTableViewCell.h"

@interface ETExpenseItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dollarAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePurchasedLabel;
@end

@implementation ETExpenseItemTableViewCell
- (void)setDollarAmountText:(NSString *)text {
    [[self dollarAmountLabel] setText:text];
}

- (void)setExpenseItemTitleText:(NSString *)text {
    [[self expenseTitleLabel] setText:text];
}

- (void)setDatePurchasedText:(NSString *)text {
    [[self datePurchasedLabel] setText:text];
}
@end
