//
//  ETAddExpenseTableViewController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "ETAddExpenseTableViewController.h"

@interface ETAddExpenseTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *expenseTitleField;
@property (weak, nonatomic) IBOutlet UITextField *expenseAmountField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePurchasedPicker;

@end

@implementation ETAddExpenseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - User Intents

- (IBAction)userDidPressCancel:(id)sender {

}

- (IBAction)userDidPressSubmit:(id)sender {
    NSString *expenseTitle = [[self expenseTitleField] text];
    NSString *amount = [[self expenseAmountField] text];
    NSDate *datePurchased = [[self datePurchasedPicker] date];
    
    if ((expenseTitle != nil) && (amount != nil)) {
        [[self itemManager]
         submitNewExpenseItemWithTitle:expenseTitle
         dollarAmount:amount
         datePurchased:datePurchased
         completionHandler:^(NSError * _Nullable error) {
            #warning handle error
            NSLog(@"%@", error);
        }];
    }
}
@end