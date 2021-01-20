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
        
        // divided by 1000 since database stores as milliseconds
        NSTimeInterval purchaseInterval = [values[ETExpenseItemDateOfPurchaseKey] doubleValue] / 1000;
        NSTimeInterval createdInterval = [values[ETExpenseItemDateCreatedKey] doubleValue] / 1000;
        
        _dateOfPurchase = [NSDate dateWithTimeIntervalSince1970:purchaseInterval];
        _dateCreated = [NSDate dateWithTimeIntervalSince1970:createdInterval];
    }
    return self;
}

- (NSDictionary<NSString *, id> *)toDictionary {
    NSTimeInterval purchaseTimestamp = round([self.dateOfPurchase timeIntervalSince1970] * 1000);
    NSTimeInterval createdTimestamp = round([self.dateCreated timeIntervalSince1970] * 1000);
    
	NSDictionary<NSString *, id> *propertyValues = @{
		ETExpenseItemIdentifierKey: [self identifier],
		ETExpenseItemAmountInCentsKey: [NSNumber numberWithInteger:[self amountInCents]],
		ETExpenseItemExpenseTitleKey: [self expenseTitle],
		ETExpenseItemExpenseDescriptionKey: [self expenseDescription],
		ETExpenseItemDateOfPurchaseKey: [NSNumber numberWithDouble:purchaseTimestamp],
        ETExpenseItemDateCreatedKey: [NSNumber numberWithDouble:createdTimestamp]};
	return propertyValues;
}
@end
