//
//  ETAuthenticationNavigationController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETAuthenticationNavigationController.h"

static void *AuthenticationControllerAuthenticationStateContext = &AuthenticationControllerAuthenticationStateContext;

@interface ETAuthenticationNavigationController ()

@end

@implementation ETAuthenticationNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self authenticationManager]
     addObserver:self
     forKeyPath:ETAuthenticationManagerStateKeyPath
     options:NSKeyValueObservingOptionNew
     context:AuthenticationControllerAuthenticationStateContext];
    [self updateRootController];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AuthenticationControllerAuthenticationStateContext) {
        NSLog(@"context did change: %@", change);
        [self updateRootController];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

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
    ETLoginViewController *controller = [ETLoginViewController initiateUsingStoryboard];
    [controller setAuthenticationManager:[self authenticationManager]];
    [self setViewControllers:@[controller] animated:YES];
}

- (void)showExpenseOverviewController {
    ETExpenseOverviewTableViewController *controller = [ETExpenseOverviewTableViewController initiateUsingStoryboard];
    
    ETItemServerProvider *server = [ETItemServerProvider new];
    ETExpenseItemManager *itemManager = [[ETExpenseItemManager alloc] initWithServerAPI:server];
    
    [controller setItemManager:itemManager];
    [self setViewControllers:@[controller] animated:YES];
}

@end
