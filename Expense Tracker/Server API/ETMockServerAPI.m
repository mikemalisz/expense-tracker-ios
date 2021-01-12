//
//  ETMockServerAPI.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/11/21.
//

#import "ETMockServerAPI.h"

@implementation ETMockServerAPI

- (void)getExpenses:(nonnull void (^)(NSArray<ETExpenseItem*>*))onCompletion {
    // configure our date formatter
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    // get raw data from the mock expenses json file
    NSString *mockExpensesPath = [[NSBundle mainBundle] pathForResource:@"mock-expenses" ofType:@".json"];
    NSData *fileData = [NSData dataWithContentsOfFile:mockExpensesPath];
    NSArray<NSDictionary*> *dictionaryList = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
    
    // get ready to create new expense items and store them in this list
    NSMutableArray *expenseItemList = [NSMutableArray new];
    
    // loop through each raw expense item in dictionary format, and
    // initialize an expense item from it
    for (NSDictionary *expenseItem in dictionaryList) {
        NSDate *dateOfPurchase = [formatter dateFromString:expenseItem[ETExpenseItemDateOfPurchaseKey]];
        NSDate *dateCreated = [formatter dateFromString:expenseItem[ETExpenseItemDateCreatedKey]];
        NSDictionary *initializationItems = @{
            ETExpenseItemIdentifierKey: expenseItem[ETExpenseItemIdentifierKey],
            ETExpenseItemAmountInCentsKey: expenseItem[ETExpenseItemAmountInCentsKey],
            ETExpenseItemExpenseTitleKey: expenseItem[ETExpenseItemExpenseTitleKey],
            ETExpenseItemExpenseDescriptionKey: expenseItem[ETExpenseItemExpenseDescriptionKey],
            ETExpenseItemDateOfPurchaseKey: dateOfPurchase,
            ETExpenseItemDateCreatedKey: dateCreated};
        ETExpenseItem *newExpenseItem = [[ETExpenseItem alloc] initWithDictionary:initializationItems];
        [expenseItemList addObject:newExpenseItem];
    }
    
    // call completion handler with a copied version of our expense item list
    onCompletion([expenseItemList copy]);
}
@end
