//
//  ETExpenseOverviewKVOManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseOverviewKVOManager.h"

static void *ExpenseOverviewItemManagerExpenseListContext = &ExpenseOverviewItemManagerExpenseListContext;

@interface ETExpenseOverviewKVOManager ()
@property ETExpenseItemManager *itemManager;
@end

@implementation ETExpenseOverviewKVOManager
- (instancetype)initWithExpenseItemManager:(ETExpenseItemManager *)itemManager {
	self = [super init];
	if (self) {
		_itemManager = itemManager;
		[self configureItemManagerObserver];
	}
	return self;
}

- (void)configureItemManagerObserver {
	[[self itemManager] addObserver:self
						 forKeyPath:ETExpenseItemManagerItemListKeyPath
							options:NSKeyValueObservingOptionNew
							context:ExpenseOverviewItemManagerExpenseListContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	if (context == ExpenseOverviewItemManagerExpenseListContext) {
		if (self.expenseItemListDidUpdate != nil) {
			self.expenseItemListDidUpdate();
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)removeObservers {
	[[self itemManager] removeObserver:self
							forKeyPath:ETExpenseItemManagerItemListKeyPath
							   context:ExpenseOverviewItemManagerExpenseListContext];
}
@end
