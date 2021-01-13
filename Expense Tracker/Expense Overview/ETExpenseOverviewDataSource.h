//
//  ETExpenseOverviewDataSource.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import <UIKit/UIKit.h>
#import "ETExpenseItemManager.h"
#import "ETExpenseItemTableViewCell.h"
#import "UITableViewCell+cellIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseOverviewDataSource : NSObject <UITableViewDataSource>
- (instancetype)initWithExpenseItemManager:(ETExpenseItemManager *)itemManager;
@end

NS_ASSUME_NONNULL_END
