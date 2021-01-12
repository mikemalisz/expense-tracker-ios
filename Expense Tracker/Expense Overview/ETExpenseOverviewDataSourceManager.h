//
//  ETExpenseOverviewDataSourceManager.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseOverviewDataSourceManager : NSObject
- (instancetype)initWithTableView:(UITableView *)tableView;

typedef NS_ENUM(NSUInteger, ETExpenseOverviewSection);
@end

NS_ASSUME_NONNULL_END
