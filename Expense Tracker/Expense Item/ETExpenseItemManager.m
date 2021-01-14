//
//  ETExpenseItemManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseItemManager.h"

NSString *const ETExpenseItemManagerItemListKeyPath = @"expenseItemList";

@interface ETExpenseItemManager ()
@property (readwrite) NSArray<ETExpenseItem *> *expenseItemList;

@property id<ETServerAPI> networkService;
@end

@implementation ETExpenseItemManager
- (instancetype)initWithServerAPI:(id<ETServerAPI>)networkService {
	self = [super init];
	if (self) {
		_networkService = networkService;
	}
	return self;
}

- (NSInteger)retrieveTotalSpend {
    NSInteger totalSpend = 0;
    for (ETExpenseItem *item in [self expenseItemList]) {
        totalSpend += item.amountInCents;
    }
    return totalSpend;
}

- (void)refreshExpenseItems {
	typeof(self) __weak weakSelf = self;
	[[self networkService] retrieveExpenseItems:^(NSArray<ETExpenseItem *> *expenseItems, NSError *error) {
		typeof(self) strongSelf = weakSelf;
		if (strongSelf) {
			[strongSelf setExpenseItemList:expenseItems];
		}
	}];
}

- (void)submitNewExpenseItemWithTitle:(NSString *)title dollarAmount:(NSString *)amountText datePurchased:(NSDate *)datePurchased completionHandler:(void (^)(NSError * _Nullable))onCompletion {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSInteger dollarAmount = [[formatter numberFromString:amountText] integerValue];
    NSNumber *amountInCents = [NSNumber numberWithInteger:(dollarAmount * 100)];
    
    NSDictionary *initializationItems = @{
        ETExpenseItemIdentifierKey: [[NSUUID new] UUIDString],
        ETExpenseItemAmountInCentsKey: amountInCents,
        ETExpenseItemExpenseTitleKey: title,
        ETExpenseItemExpenseDescriptionKey: @"",
        ETExpenseItemDateOfPurchaseKey: datePurchased,
        ETExpenseItemDateCreatedKey: [NSDate new]};
    
    ETExpenseItem *newItem = [[ETExpenseItem alloc] initWithDictionary:initializationItems];
    [[self networkService] persistNewExpenseItem:newItem completionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
        onCompletion(error);
    }];
}

- (void)deleteExpenseItem:(ETExpenseItem *)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion {
    
    [[self networkService] deleteExpenseItem:expenseItem completionHandler:^(NSError * _Nullable error) {
        onCompletion(error);
    }];
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(ETExpenseItem  *obj, id bindings) {
        return obj.identifier == expenseItem.identifier;
    }];
    NSArray *filteredExpenseItems = [[self expenseItemList] filteredArrayUsingPredicate:filterPredicate];
    [self setExpenseItemList:filteredExpenseItems];
}
@end
