//
//  ETExpenseOverviewDataSource.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseOverviewDataSource.h"

typedef NS_ENUM(NSUInteger, ETExpenseOverviewSection) {
    totalSpendOverview,
    expenseItems
};

@interface ETExpenseOverviewDataSource ()
@property ETExpenseItemManager *itemManager;
@end

@implementation ETExpenseOverviewDataSource

- (instancetype)initWithExpenseItemManager:(ETExpenseItemManager *)itemManager {
	self = [super init];
	if (self) {
		_itemManager = itemManager;
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ETExpenseOverviewSection expenseOverviewSection = section;
    switch (expenseOverviewSection) {
        case totalSpendOverview: return 1;
        case expenseItems:
			return [[[self itemManager] expenseItemList] count];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	ETExpenseOverviewSection section = [indexPath section];
    switch (section) {
        case totalSpendOverview:
            return [self totalSpendOverviewCellForTableView:tableView at:indexPath];
        case expenseItems: return [self expenseItemCellForTableView:tableView at:indexPath];
    }
}

- (UITableViewCell*)totalSpendOverviewCellForTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalSpendOverviewCell" forIndexPath:indexPath];
    [[cell textLabel] setText:@"yee"];
    return cell;
}

- (UITableViewCell*)expenseItemCellForTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath {
    ETExpenseItemTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:[ETExpenseItemTableViewCell cellIdentifier]
                                        forIndexPath:indexPath];
    ETExpenseItem *expenseItem = [[[self itemManager] expenseItemList] objectAtIndex:[indexPath row]];
    if (expenseItem != nil) {
        [cell updateCellUsingExpenseItem:expenseItem];
    }
    return cell;
}
@end
