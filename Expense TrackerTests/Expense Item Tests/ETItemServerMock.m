//
//  ETItemServerMock.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import "ETItemServerMock.h"

@implementation ETItemServerMock

+ (ETItemServerMock *)itemServerMockWithCompletionHandlerData:(NSDictionary * _Nullable)data error:(NSError * _Nullable)error {
    ETItemServerMock *itemServer = [ETItemServerMock new];
    [itemServer setCompletionHandlerData:data];
    [itemServer setCompletionHandlerError:error];
    return itemServer;
}

- (void)deleteExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion {
    if (self.onDeleteItemActionWithProvidedData) {
        self.onDeleteItemActionWithProvidedData(expenseItem);
    }
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

- (void)persistNewExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion {
    if (self.onPersistItemActionWithProvidedData) {
        self.onPersistItemActionWithProvidedData(expenseItem);
    }
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

- (void)retrieveExpenseItems:(ServerCompletionHandler)onCompletion {
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

- (void)updateExistingExpenseItem:(NSData *)expenseItem completionHandler:(ServerCompletionHandler)onCompletion {
    if (self.onUpdateItemActionWithProvidedData) {
        self.onUpdateItemActionWithProvidedData(expenseItem);
    }
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

@end
