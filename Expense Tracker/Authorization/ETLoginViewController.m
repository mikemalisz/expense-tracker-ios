//
//  ETLoginViewController.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/14/21.
//

#import "ETLoginViewController.h"

@interface ETLoginViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *loginProviderStackView;

@end

@implementation ETLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSignInButton];
}

- (void)configureSignInButton {
    ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton new];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button addTarget:self action:@selector(handleSignInButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.loginProviderStackView addArrangedSubview:button];
    
    [NSLayoutConstraint activateConstraints:@[
        [button.heightAnchor constraintEqualToConstant:44],
        [button.widthAnchor constraintEqualToConstant:240]
    ]];
}

- (void)handleSignInButtonPress {
    ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    [request setRequestedScopes:@[ASAuthorizationScopeEmail]];

    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    [controller setDelegate:[self authenticationManager]];
    [controller setPresentationContextProvider:self];
    [controller performRequests];
}

#pragma mark - Authorizaton Context Providing

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return [[self view] window];
}

@end
