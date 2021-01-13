//
//  ETExpenseOverviewTableViewController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import "ETExpenseOverviewTableViewController.h"

@interface ETExpenseOverviewTableViewController ()
@property ETExpenseOverviewDataSource *dataSource;
@property ETExpenseOverviewKVOManager *propertyObserver;
@end

@implementation ETExpenseOverviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ETExpenseOverviewDataSource *dataSource = [[ETExpenseOverviewDataSource alloc] initWithExpenseItemManager:[self itemManager]];
    [self setDataSource:dataSource];
    [[self tableView] setDataSource:dataSource];
	
	[self configurePropertyObserver];
	[[self itemManager] refreshExpenseItems];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[self propertyObserver] removeObservers];
}

- (void)configurePropertyObserver {
	ETExpenseOverviewKVOManager *propertyObserver = [[ETExpenseOverviewKVOManager alloc] initWithExpenseItemManager:[self itemManager]];
	[self setPropertyObserver:propertyObserver];
	
	[[self propertyObserver] setExpenseItemListDidUpdate:^{
		NSLog(@"Property Observed!");
	}];
}

@end
