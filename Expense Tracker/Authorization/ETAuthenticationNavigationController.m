//
//  ETAuthenticationNavigationController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETAuthenticationNavigationController.h"

static void *AuthenticationControllerAuthenticationStateContext = &AuthenticationControllerAuthenticationStateContext;

@interface ETAuthenticationNavigationController ()

@property ETAuthenticationManager *authenticationManager;

@end

@implementation ETAuthenticationNavigationController

#pragma mark - Initialization

- (void)configureWithAuthenticationManager:(ETAuthenticationManager *)authenticationManager {
    [self setAuthenticationManager:authenticationManager];
    
    typeof(self) __weak weakSelf = self;
    [self.authenticationManager setHandleErrorAction:^(NSError *error) {
        if (weakSelf.isViewLoaded) {
            [weakSelf displayErrorAlertWithMessage:error.localizedDescription];
        }
    }];
    
    [self.authenticationManager refreshAuthenticationStatus];
}

#pragma mark - Controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self attachObservers];
    [self updateRootController];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObservers];
}

#pragma mark - KVO

- (void)attachObservers {
    [self.authenticationManager
     addObserver:self
     forKeyPath:ETAuthenticationManagerStateKeyPath
     options:NSKeyValueObservingOptionNew
     context:AuthenticationControllerAuthenticationStateContext];
}

- (void)removeObservers {
    [self.authenticationManager
     removeObserver:self
     forKeyPath:ETAuthenticationManagerStateKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AuthenticationControllerAuthenticationStateContext) {
        [self updateRootController];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Navigation

- (void)updateRootController {
    switch ([self.authenticationManager authenticationState]) {
        case ETUnauthenticated:
            [self showLoginController];
            break;
        case ETAuthenticated:
            [self showExpenseOverviewController];
            break;
    }
}

- (void)showLoginController {
    [self setNavigationBarHidden:YES animated:NO];
    
    ETLoginViewController *controller = [ETLoginViewController initiateUsingStoryboard];
    [controller setAuthenticationManager:[self authenticationManager]];
    [self setViewControllers:@[controller] animated:YES];
}

- (void)showExpenseOverviewController {
    [self setNavigationBarHidden:NO animated:NO];
    
    ETExpenseOverviewTableViewController *controller = [ETExpenseOverviewTableViewController initiateUsingStoryboard];
    
    ETItemServerProvider *server = [ETItemServerProvider new];
    ETExpenseItemManager *itemManager = [[ETExpenseItemManager alloc] initWithServerAPI:server];
    
    [controller setItemManager:itemManager];
    [self setViewControllers:@[controller] animated:YES];
}

@end
