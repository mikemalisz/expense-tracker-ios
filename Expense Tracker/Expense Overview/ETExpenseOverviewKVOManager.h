//
//  ETExpenseOverviewKVOManager.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import <Foundation/Foundation.h>
#import "ETExpenseItemManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseOverviewKVOManager : NSObject

@property (copy, nullable) void (^expenseItemListDidUpdate)(void);
- (instancetype)initWithExpenseItemManager:(ETExpenseItemManager *)itemManager;
- (void)removeObservers;

@end

NS_ASSUME_NONNULL_END
