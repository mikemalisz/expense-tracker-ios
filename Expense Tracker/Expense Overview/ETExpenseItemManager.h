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

extern NSString *const ETExpenseItemManagerItemListKeyPath;

@interface ETExpenseItemManager : NSObject
@property (readonly) NSArray<ETExpenseItem *> *expenseItemList;

- (instancetype)initWithServerAPI:(id<ETServerAPI>)networkService;

- (NSInteger)retrieveTotalSpend;
- (void)refreshExpenseItems;

- (void)submitNewExpenseItemWithTitle:(NSString *)title dollarAmount:(NSString *)amount datePurchased:(NSDate *)datePurchased;
@end

NS_ASSUME_NONNULL_END
