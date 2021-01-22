//
//  ETExpenseOverviewDataSource.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseOverviewDataSource.h"

#pragma mark - Constants

NSString * const ETExpenseItemSectionTitle = @"Itemized";

#pragma mark - Properties

@interface ETExpenseOverviewDataSource ()
@property ETExpenseItemManager *itemManager;
@end

#pragma mark - Methods

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

#pragma mark - Cell Providers

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	ETExpenseOverviewSection section = [indexPath section];
    switch (section) {
        case ETExpenseOverviewSectionTotalSpendOverview:
            return [self totalSpendOverviewCellForTableView:tableView at:indexPath];
        case ETExpenseOverviewSectionExpenseItems: return [self expenseItemCellForTableView:tableView at:indexPath];
    }
}

- (UITableViewCell*)totalSpendOverviewCellForTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath {
    ETSpendSummaryTableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:[ETSpendSummaryTableViewCell cellIdentifier]
                             forIndexPath:indexPath];
    NSInteger totalSpend = [self.itemManager retrieveTotalSpend];
    [cell setSpendAmountFromCents:totalSpend];
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

#pragma mark - Row Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ETExpenseOverviewSection section = indexPath.section;
    switch (section) {
        case ETExpenseOverviewSectionExpenseItems:
            return YES;
            
        default:
            return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *itemList = [[self itemManager] expenseItemList];
        ETExpenseItem *item = [itemList objectAtIndex:[indexPath row]];
        
        typeof(self) __weak weakSelf = self;
        [self.itemManager deleteExpenseItemWithItemId:item.identifier completionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                weakSelf.handleErrorAction(error);
            }
        }];
    }
}

#pragma mark - Section Titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ((ETExpenseOverviewSection)section) {
        case ETExpenseOverviewSectionExpenseItems: {
            BOOL isItemListEmpty = (self.itemManager.expenseItemList.count == 0);
            return isItemListEmpty ? nil : ETExpenseItemSectionTitle;
        }
        default: return nil;
    }
}
@end
