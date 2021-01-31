//
//  ETSpendSummaryTableViewCell.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "ETSpendSummaryTableViewCell.h"

static NSNumberFormatter *dollarFormatter = nil;

@implementation ETSpendSummaryTableViewCell
- (void)setSpendAmountFromCents:(NSInteger)amountInCents {
    double dollarAmount = amountInCents * ETExpenseItemCentsToDollarsMultiplier;
    
    if (dollarFormatter == nil) {
        dollarFormatter = [NSNumberFormatter new];
        [dollarFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    NSString *spendAmount = [dollarFormatter stringFromNumber:[NSNumber numberWithDouble:dollarAmount]];
    
    [self.spendAmountLabel setText:spendAmount];
}
@end
