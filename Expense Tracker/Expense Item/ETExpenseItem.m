//
//  ETExpenseItem.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import "ETExpenseItem.h"

NSString *const ETExpenseItemIdentifierKey = @"itemId";
NSString *const ETExpenseItemAmountInCentsKey = @"amountInCents";
NSString *const ETExpenseItemExpenseTitleKey = @"expenseTitle";
NSString *const ETExpenseItemExpenseDescriptionKey = @"expenseDescription";
NSString *const ETExpenseItemDateOfPurchaseKey = @"dateOfPurchase";
NSString *const ETExpenseItemDateCreatedKey = @"dateCreated";


@implementation ETExpenseItem

- (nullable instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)values {
    self = [super init];
    if (self) {
        
        NSArray *requiredDictionaryKeys = @[
            ETExpenseItemIdentifierKey,
            ETExpenseItemAmountInCentsKey,
            ETExpenseItemExpenseTitleKey,
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
        _expenseTitle = values[ETExpenseItemExpenseTitleKey];
        _expenseDescription = values[ETExpenseItemExpenseDescriptionKey];
        _dateOfPurchase = values[ETExpenseItemDateOfPurchaseKey];
        _dateCreated = values[ETExpenseItemDateCreatedKey];
    }
    return self;
}

- (NSDictionary<NSString *, id> *)toDictionary {
    NSNumber *dateOfPurchaseTimestamp = [NSNumber numberWithDouble:[[self dateOfPurchase] timeIntervalSince1970]];
    NSNumber *dateCreatedTimestamp = [NSNumber numberWithDouble:[[self dateCreated] timeIntervalSince1970]];
    
	NSDictionary<NSString *, id> *propertyValues = @{
		ETExpenseItemIdentifierKey: [self identifier],
		ETExpenseItemAmountInCentsKey: [NSNumber numberWithInteger:[self amountInCents]],
		ETExpenseItemExpenseTitleKey: [self expenseTitle],
		ETExpenseItemExpenseDescriptionKey: [self expenseDescription],
		ETExpenseItemDateOfPurchaseKey: dateOfPurchaseTimestamp,
        ETExpenseItemDateCreatedKey: dateCreatedTimestamp};
	return propertyValues;
}
@end
