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
@end

@implementation ETExpenseOverviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ETExpenseOverviewSection expenseOverviewSection = section;
    switch (expenseOverviewSection) {
        case totalSpendOverview: return 1;
        case expenseItems: return 1;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseItemCell" forIndexPath:indexPath];
    
    return cell;
}
@end
