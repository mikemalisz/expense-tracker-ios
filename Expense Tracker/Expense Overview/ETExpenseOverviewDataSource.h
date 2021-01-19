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
#import "ETSpendSummaryTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ETExpenseOverviewSection) {
    ETExpenseOverviewSectionTotalSpendOverview = 0,
    ETExpenseOverviewSectionExpenseItems
};

@interface ETExpenseOverviewDataSource : NSObject <UITableViewDataSource>
- (instancetype)initWithExpenseItemManager:(ETExpenseItemManager *)itemManager;

@property void (^ _Nullable handleErrorAction)(NSError *);

@end

NS_ASSUME_NONNULL_END
