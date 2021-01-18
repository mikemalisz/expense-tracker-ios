//
//  ETSpendSummaryTableViewCell.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "ETSpendSummaryTableViewCell.h"

@implementation ETSpendSummaryTableViewCell
- (void)setSpendAmountFromCents:(NSInteger)amountInCents {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMultiplier:[NSNumber numberWithDouble:0.01]];
    NSString *spendAmount = [formatter stringFromNumber:[NSNumber numberWithInteger:amountInCents]];
    
    [self.spendAmountLabel setText:spendAmount];
}
@end
