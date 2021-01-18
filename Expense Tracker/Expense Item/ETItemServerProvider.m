//
//  ETItemServerProvider.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETItemServerProvider.h"

@implementation ETItemServerProvider

- (void)deleteExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nullable))onCompletion {
}

- (void)persistNewExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nullable))onCompletion {
}

- (void)retrieveExpenseItems:(nonnull void (^)(NSArray<ETExpenseItem *> * _Nonnull, NSError * _Nullable))onCompletion {
}

- (void)updateExistingExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nullable))onCompletion {
}

@end
