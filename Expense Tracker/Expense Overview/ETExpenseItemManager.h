//
//  ETExpenseItemManager.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import <Foundation/Foundation.h>
#import "ETServerAPI.h"
#import "ETExpenseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETExpenseItemManager : NSObject
@property (readonly) NSArray<ETExpenseItem *> *expenseItemList;

- (instancetype)initWithServerAPI:(id<ETServerAPI>)networkService;

- (void)refreshExpenseItems;
@end

NS_ASSUME_NONNULL_END
