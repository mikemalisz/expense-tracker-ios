//
//  ETItemServer.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <Foundation/Foundation.h>
#import "ETExpenseItem.h"
#import "ETServerCompletionHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETItemServer
- (void)retrieveExpenseItems:(ServerCompletionHandler)onCompletion;

- (void)persistNewExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion;

- (void)updateExistingExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion;

- (void)deleteExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion;
@end

NS_ASSUME_NONNULL_END
