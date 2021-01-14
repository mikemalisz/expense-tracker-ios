//
//  ETExpenseItem.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import "ETExpenseItem.h"

NSString *const ETExpenseItemIdentifierKey = @"id";
NSString *const ETExpenseItemAmountInCentsKey = @"amountInCents";
NSString *const ETExpenseItemExpenseTitleKey = @"title";
NSString *const ETExpenseItemExpenseDescriptionKey = @"description";
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
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
	NSDictionary<NSString *, id> *propertyValues = @{
		ETExpenseItemIdentifierKey: [self identifier],
		ETExpenseItemAmountInCentsKey: [NSNumber numberWithInteger:[self amountInCents]],
		ETExpenseItemExpenseTitleKey: [self expenseTitle],
		ETExpenseItemExpenseDescriptionKey: [self expenseDescription],
		ETExpenseItemDateOfPurchaseKey: [dateFormatter stringFromDate:[self dateOfPurchase]],
        ETExpenseItemDateCreatedKey: [dateFormatter stringFromDate:[self dateCreated]]};
	return propertyValues;
}
@end
