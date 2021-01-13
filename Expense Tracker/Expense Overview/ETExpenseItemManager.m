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

- (void)refreshExpenseItems {
	typeof(self) __weak weakSelf = self;
	[[self networkService] retrieveExpenseItems:^(NSArray<ETExpenseItem *> *expenseItems, NSError *error) {
		typeof(self) strongSelf = weakSelf;
		if (strongSelf) {
			[strongSelf setExpenseItemList:expenseItems];
		}
	}];
}
@end