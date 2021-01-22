//
//  ETSpendSummaryTableViewCell.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "ETSpendSummaryTableViewCell.h"

@implementation ETSpendSummaryTableViewCell
- (void)setSpendAmountFromCents:(NSInteger)amountInCents {
    double dollarAmount = amountInCents * ETExpenseItemCentsToDollarsMultiplier;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *spendAmount = [formatter stringFromNumber:[NSNumber numberWithDouble:dollarAmount]];
    
    [self.spendAmountLabel setText:spendAmount];
}
@end
