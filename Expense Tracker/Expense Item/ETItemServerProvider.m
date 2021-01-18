//
//  ETItemServerProvider.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETItemServerProvider.h"

@implementation ETItemServerProvider

- (void)retrieveExpenseItems:(ServerCompletionHandler)onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"expense-items/retrieve"];
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

- (void)persistNewExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"expense-items/create"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:expenseItem];
    
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

- (void)updateExistingExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion {
    NSAssert(NO, @"Unimplemented");
}

- (void)deleteExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"expense-items/"];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:expenseItem];
    
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

@end
