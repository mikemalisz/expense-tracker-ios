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

- (void)updateCellUsingExpenseItem:(ETExpenseItem *)expenseItem {
    // dollar amount
    NSString *dollarAmountText = [NSString stringWithFormat:@"%ld", [expenseItem amountInCents]];
    [[self dollarAmountLabel] setText:dollarAmountText];
    
    // item title
    [[self expenseTitleLabel] setText:[expenseItem expenseTitle]];
    
    // date of purchase
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateOfPurchaseText = [formatter stringFromDate:[expenseItem dateOfPurchase]];
    
    [[self datePurchasedLabel] setText:dateOfPurchaseText];
}

@end
