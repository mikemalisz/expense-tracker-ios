//
//  ETAddExpenseTableViewController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "ETAddExpenseTableViewController.h"

typedef NS_ENUM(NSUInteger, ETAddExpenseTextFieldTag) {
    ETAddExpenseTitleTextFieldTag,
    ETAddExpenseAmountTextFieldTag
};

@interface ETAddExpenseTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *expenseTitleField;
@property (weak, nonatomic) IBOutlet UITextField *expenseAmountField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePurchasedPicker;

@end

@implementation ETAddExpenseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextFields];
}

#pragma mark - User Intents

- (IBAction)userDidPressCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)userDidPressSubmit:(id)sender {
    NSString *expenseTitle = [[self expenseTitleField] text];
    NSString *amount = [[self expenseAmountField] text];
    NSDate *datePurchased = [[self datePurchasedPicker] date];
    
    if ((expenseTitle != nil) && (amount != nil)) {
        typeof(self) __weak weakSelf = self;
        [self.itemManager
         submitNewExpenseItemWithTitle:expenseTitle
         description:[NSString new]
         dollarAmount:amount
         datePurchased:datePurchased
         completionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                [weakSelf displayErrorAlertWithMessage:error.localizedDescription];
            } else {
                [weakSelf dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }
}

#pragma mark - Configuration

- (void)configureTextFields {
    [self.expenseTitleField setDelegate:self];
    [self.expenseAmountField setDelegate:self];
    [self.expenseTitleField becomeFirstResponder];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    ETAddExpenseTextFieldTag fieldTag = textField.tag;
    switch (fieldTag) {
        case ETAddExpenseTitleTextFieldTag:
            [self.expenseAmountField becomeFirstResponder];
            break;
        case ETAddExpenseAmountTextFieldTag:
            [self.datePurchasedPicker becomeFirstResponder];
            break;
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
@end
