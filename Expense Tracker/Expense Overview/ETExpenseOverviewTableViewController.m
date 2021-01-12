//
//  ETExpenseOverviewTableViewController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import "ETExpenseOverviewTableViewController.h"

@interface ETExpenseOverviewTableViewController ()
@property ETExpenseOverviewDataSource *dataSource;
@end

@implementation ETExpenseOverviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ETExpenseOverviewDataSource *dataSource = [[ETExpenseOverviewDataSource alloc] init];
    [self setDataSource:dataSource];
    [[self tableView] setDataSource:dataSource];
    
    [[self networkService] retrieveExpenseItems:^(NSArray<ETExpenseItem*> *expenseItems, NSError *error) {
		if (error != nil) {
			NSLog(@"%@", error);
		}
		for (ETExpenseItem *item in expenseItems) {
            NSLog(@"%@", item.identifier);
        }
    }];
}

@end
