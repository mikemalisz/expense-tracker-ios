//
//  ETMockServerAPI.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/11/21.
//

#import <Foundation/Foundation.h>
#import "ETServerAPI.h"
#import "NSFileManager+documentsDirectoryForCurrentUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETMockServerAPI : NSObject<ETServerAPI>
- (void)retrieveExpenseItems:(void (^)(NSArray<ETExpenseItem *>*, NSError * _Nullable))onCompletion;
- (void)persistNewExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion;
- (void)updateExistingExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion;
- (void)deleteExpenseItem:(ETExpenseItem*)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion;
@end

NS_ASSUME_NONNULL_END
