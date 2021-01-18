//
//  ETSpendSummaryTableViewCell.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETSpendSummaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spendTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spendAmountLabel;

- (void)setSpendAmountFromCents:(NSInteger)amountInCents;
@end

NS_ASSUME_NONNULL_END
