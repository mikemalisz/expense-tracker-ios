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

- (void)submitNewExpenseItemWithTitle:(NSString *)title dollarAmount:(NSString *)amount datePurchased:(NSDate *)datePurchased completionHandler:(void (^)(NSError * nullable))onCompletion {
    NSLog(@"to be implemented");
    
    onCompletion(nil);
}
@end
