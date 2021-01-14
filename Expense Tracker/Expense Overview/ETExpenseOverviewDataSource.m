//
//  ETExpenseOverviewDataSource.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseOverviewDataSource.h"

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
        case ETExpenseOverviewSectionTotalSpendOverview: return 1;
        case ETExpenseOverviewSectionExpenseItems:
			return [[[self itemManager] expenseItemList] count];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	ETExpenseOverviewSection section = [indexPath section];
    switch (section) {
        case ETExpenseOverviewSectionTotalSpendOverview:
            return [self totalSpendOverviewCellForTableView:tableView at:indexPath];
        case ETExpenseOverviewSectionExpenseItems: return [self expenseItemCellForTableView:tableView at:indexPath];
    }
}

- (UITableViewCell*)totalSpendOverviewCellForTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalSpendOverviewCell" forIndexPath:indexPath];
    
    NSInteger totalSpend = [[self itemManager] retrieveTotalSpend];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%ld", totalSpend]];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *itemList = [[self itemManager] expenseItemList];
        ETExpenseItem *item = [itemList objectAtIndex:[indexPath row]];
        
        [[self itemManager] deleteExpenseItem:item completionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                #warning handle error
            }
        }];
    }
}
@end
