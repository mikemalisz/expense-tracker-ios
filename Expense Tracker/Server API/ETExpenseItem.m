//
//  ETExpenseItem.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import "ETExpenseItem.h"

static NSString *const ETExpenseItemIdentifierKey = @"id";
static NSString *const ETExpenseItemAmountInCentsKey = @"amountInCents";
static NSString *const ETExpenseItemTitleKey = @"title";
static NSString *const ETExpenseItemExpenseDescriptionKey = @"description";
static NSString *const ETExpenseItemDateOfPurchaseKey = @"dateOfPurchase";
static NSString *const ETExpenseItemDateCreatedKey = @"dateCreated";


@implementation ETExpenseItem

- (nullable instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)values {
    self = [super init];
    if (self) {
        
        NSArray *requiredDictionaryKeys = @[
            ETExpenseItemIdentifierKey,
            ETExpenseItemAmountInCentsKey,
            ETExpenseItemTitleKey,
            ETExpenseItemExpenseDescriptionKey,
            ETExpenseItemDateOfPurchaseKey,
            ETExpenseItemDateCreatedKey];
        
        for (NSString *key in requiredDictionaryKeys) {
            if ([values objectForKey:key] == nil) {
                return nil;
            }
        }
        
        _identifier = values[ETExpenseItemIdentifierKey];
        _amountInCents = [values[ETExpenseItemAmountInCentsKey] integerValue];
        _expenseTitle = values[ETExpenseItemTitleKey];
        _expenseDescription = values[ETExpenseItemExpenseDescriptionKey];
        _dateOfPurchase = values[ETExpenseItemDateOfPurchaseKey];
        _dateCreated = values[ETExpenseItemDateCreatedKey];
    }
    return self;
}
@end
