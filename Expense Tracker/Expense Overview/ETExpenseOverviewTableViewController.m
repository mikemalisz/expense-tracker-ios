//
//  ETExpenseOverviewTableViewController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import "ETExpenseOverviewTableViewController.h"

@interface ETExpenseOverviewTableViewController ()
@property ETExpenseOverviewDataSourceManager *dataSource;
@end

@implementation ETExpenseOverviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ETExpenseOverviewDataSourceManager *newDataSource = [[ETExpenseOverviewDataSourceManager alloc] initWithTableView:[self tableView]];
    [self setDataSource: newDataSource];
    
    [[self networkService] getExpenses:^(NSArray<ETExpenseItem*> *expenseItems) {
        for (ETExpenseItem *item in expenseItems) {
            NSLog(@"%@", item.identifier);
        }
    }];
}

@end
