//
//  ETServerAPI.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <Foundation/Foundation.h>
#import "ETExpenseItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETServerAPI
- (void)retrieveExpenseItems:(void (^)(NSArray<ETExpenseItem*>*, NSError * _Nullable))onCompletion;
- (void)persistNewExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion;
- (void)updateExistingExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion;
- (void)deleteExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion;
@end

NS_ASSUME_NONNULL_END
