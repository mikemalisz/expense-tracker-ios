//
//  ETExpenseItemManager.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import <Foundation/Foundation.h>
#import "ETItemServer.h"
#import "ETExpenseItem.h"
#import "ETAppError.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const ETExpenseItemManagerItemListKeyPath;

@interface ETExpenseItemManager : NSObject
@property (readonly) NSArray<ETExpenseItem *> *expenseItemList;

- (instancetype)initWithServerAPI:(id<ETItemServer>)networkService;

- (NSInteger)retrieveTotalSpend;

- (void)refreshExpenseItemsWithCompletionHandler:(void (^)(NSError * _Nullable))onCompletion;

- (void)submitNewExpenseItemWithTitle:(NSString *)title description:(NSString *)expenseDescription dollarAmount:(NSString *)amountText datePurchased:(NSDate *)datePurchased completionHandler:(void (^)(NSError * _Nullable))onCompletion;

- (void)deleteExpenseItemWithItemId:(NSString *)itemId completionHandler:(void (^)(NSError * _Nullable))onCompletion;

@end
NS_ASSUME_NONNULL_END
