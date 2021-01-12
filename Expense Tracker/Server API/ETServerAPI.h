//
//  ETServerAPI.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <Foundation/Foundation.h>
#import "ETExpenseItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETServerAPI <NSObject>
- (void)retrieveExpenseItems:(void (^)(NSArray<ETExpenseItem*>*, NSError*))onCompletion;
- (void)createExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError*))onCompletion;
- (void)updateExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError*))onCompletion;
- (void)deleteExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError*))onCompletion;
@end

NS_ASSUME_NONNULL_END
