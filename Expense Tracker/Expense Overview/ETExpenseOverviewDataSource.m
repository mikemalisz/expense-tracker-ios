//
//  ETExpenseOverviewDataSource.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseOverviewDataSource.h"

@interface ETExpenseOverviewDataSource ()
@property UITableView *tableView;
@property UITableViewDiffableDataSource *dataSource;
@end

@implementation ETExpenseOverviewDataSource
- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

- (nullable UITableViewCell*)cellProviderForDataSourceWithTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath with:(id)item {
    NSLog(@"%ld", [indexPath section]);
    switch ([indexPath section]) {
        case totalSpendOverview:
            return [self totalSpendOverviewCellForTableView:tableView at:indexPath with:item];
        case expenseItems:
            return [self expenseItemCellForTableView:tableView at:indexPath with:item];
        default:
            return nil;
    }
}

- (UITableViewCell*)totalSpendOverviewCellForTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath with:(id)item {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalSpendOverviewCell" forIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell*)expenseItemCellForTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath with:(id)item {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseItemCell" forIndexPath:indexPath];
    
    return cell;
}

typedef NS_ENUM(NSUInteger, ETExpenseOverviewSection) {
    totalSpendOverview,
    expenseItems
};
@end
