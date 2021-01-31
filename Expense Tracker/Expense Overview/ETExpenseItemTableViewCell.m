//
//  ETExpenseItemTableViewCell.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "ETExpenseItemTableViewCell.h"

static NSDateFormatter *dateOfPurchaseFormatter = nil;
static NSNumberFormatter *dollarFormatter = nil;

@interface ETExpenseItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dollarAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePurchasedLabel;
@end

@implementation ETExpenseItemTableViewCell

- (void)updateCellUsingExpenseItem:(ETExpenseItem *)expenseItem {
    
    // dollar amount
    NSString *dollarAmountText = [self createFormattedDollarAmountFromCents:expenseItem.amountInCents];
    [self.dollarAmountLabel setText:dollarAmountText];
    
    // item title
    [self.expenseTitleLabel setText:[expenseItem expenseTitle]];
    
    // date of purchase
    if (dateOfPurchaseFormatter == nil) {
        dateOfPurchaseFormatter = [NSDateFormatter new];
        [dateOfPurchaseFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateOfPurchaseFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    
    NSString *dateOfPurchaseText = [dateOfPurchaseFormatter stringFromDate:expenseItem.dateOfPurchase];
    [self.datePurchasedLabel setText:dateOfPurchaseText];
}

- (NSString *)createFormattedDollarAmountFromCents:(NSInteger)cents {
    double dollarAmount = cents * ETExpenseItemCentsToDollarsMultiplier;
    
    if (dollarFormatter == nil) {
        dollarFormatter = [NSNumberFormatter new];
        [dollarFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return [dollarFormatter stringFromNumber:[NSNumber numberWithDouble:dollarAmount]];
}

@end
