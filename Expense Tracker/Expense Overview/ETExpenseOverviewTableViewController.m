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
    
    ETExpenseOverviewDataSource *dataSource = [[ETExpenseOverviewDataSource alloc] initWithExpenseItemManager:[self itemManager]];
    [self setDataSource:dataSource];
    [[self tableView] setDataSource:dataSource];
    
	[[self itemManager] addObserver:self
						 forKeyPath:ETExpenseItemManagerItemListKeyPath
							options:NSKeyValueObservingOptionNew
							context:nil];
	
	[[self itemManager] refreshExpenseItems];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	NSLog(@"observing....");
	ETExpenseItemManager *itemManager = object;
	if (itemManager) {
		NSLog(@"%@", change);
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
