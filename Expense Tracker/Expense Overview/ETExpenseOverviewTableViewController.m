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

#pragma mark - Controller Lifecycle

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

#pragma mark - Configuration

- (void)configurePropertyObserver {
	ETExpenseOverviewKVOManager *propertyObserver = [[ETExpenseOverviewKVOManager alloc] initWithExpenseItemManager:[self itemManager]];
	[self setPropertyObserver:propertyObserver];
	
    typeof(self) __weak weakSelf = self;
	[[self propertyObserver] setExpenseItemListDidUpdate:^{
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf != nil) {
            [[strongSelf tableView] reloadSections:[NSIndexSet indexSetWithIndex:ETExpenseOverviewSectionExpenseItems] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
	}];
}

#pragma mark - Add Expense Button

- (IBAction)didPressAddExpense:(UIBarButtonItem *)sender {
    ETAddExpenseTableViewController *controller = [ETAddExpenseTableViewController initiateUsingStoryboard];
    [controller setItemManager:[self itemManager]];
    [self presentViewController:controller animated:true completion:nil];
}

@end
