//
//  ETExpenseItemTableViewCell.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "ETExpenseItemTableViewCell.h"

float ETExpenseItemCentsToDollarsMultiplier = 0.01;

@interface ETExpenseItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dollarAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePurchasedLabel;
@end

@implementation ETExpenseItemTableViewCell

- (void)updateCellUsingExpenseItem:(ETExpenseItem *)expenseItem {
    
    // dollar amount
    NSString *dollarAmountText = [self createFormattedDollarAmountFromCents:[expenseItem amountInCents]];
    [[self dollarAmountLabel] setText:dollarAmountText];
    
    // item title
    [[self expenseTitleLabel] setText:[expenseItem expenseTitle]];
    
    // date of purchase
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateOfPurchaseText = [formatter stringFromDate:expenseItem.dateOfPurchase];
    
    [[self datePurchasedLabel] setText:dateOfPurchaseText];
}

- (NSString *)createFormattedDollarAmountFromCents:(NSInteger)cents {
    double dollarAmount = cents * ETExpenseItemCentsToDollarsMultiplier;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:dollarAmount]];
}

@end
