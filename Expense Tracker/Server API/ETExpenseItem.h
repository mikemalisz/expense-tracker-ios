//
//  ETExpenseItem.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const ETExpenseItemIdentifierKey;
static NSString *const ETExpenseItemAmountInCentsKey;
static NSString *const ETExpenseItemTitleKey;
static NSString *const ETExpenseItemExpenseDescriptionKey;
static NSString *const ETExpenseItemDateOfPurchaseKey;
static NSString *const ETExpenseItemDateCreatedKey;

@interface ETExpenseItem : NSObject
@property NSString *identifier;
@property NSInteger amountInCents;
@property NSString *expenseTitle;
@property NSString *expenseDescription;
@property NSDate *dateOfPurchase;
@property NSDate *dateCreated;

- (nullable instancetype)initWithDictionary:(NSDictionary<NSString*, id>*)values;
@end

NS_ASSUME_NONNULL_END
