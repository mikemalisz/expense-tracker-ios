//
//  ETExpenseItem.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// convenience for converting between cents and dollars
extern double const ETExpenseItemCentsToDollarsMultiplier;

// property key paths
extern NSString *const ETExpenseItemIdentifierKey;
extern NSString *const ETExpenseItemAmountInCentsKey;
extern NSString *const ETExpenseItemExpenseTitleKey;
extern NSString *const ETExpenseItemExpenseDescriptionKey;
extern NSString *const ETExpenseItemDateOfPurchaseKey;
extern NSString *const ETExpenseItemDateCreatedKey;

@interface ETExpenseItem : NSObject
@property NSString *identifier;
@property NSInteger amountInCents;
@property NSString *expenseTitle;
@property NSString *expenseDescription;
@property NSDate *dateOfPurchase;
@property NSDate *dateCreated;

- (nullable instancetype)initWithDictionary:(NSDictionary<NSString*, id>*)values;
- (NSDictionary *)toDictionary;
@end

NS_ASSUME_NONNULL_END
