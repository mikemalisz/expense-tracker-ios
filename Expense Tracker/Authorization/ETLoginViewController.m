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
    [button addTarget:self action:@selector(handleSignInButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [[self loginProviderStackView] addArrangedSubview:button];
}

- (void)handleSignInButtonPress {
    ETServerProvider *provider = [ETServerProvider new];
    [provider testServerConnection];
    
    
//    ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
//    ASAuthorizationAppleIDRequest *request = [provider createRequest];
//    [request setRequestedScopes:@[ASAuthorizationScopeEmail]];
//
//    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
//    [controller setDelegate:self];
//    [controller setPresentationContextProvider:self];
//    [controller performRequests];
}

#pragma mark - Authorizaton Controller Delegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    id credential = [authorization credential];
    
    if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        NSLog(@"ASAuthorizatonAppleIDCredential: %@", credential);
    } else if ([credential isKindOfClass:[ASPasswordCredential class]]) {
        NSLog(@"ASPasswordCredential: %@", credential);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    #warning handle error
    NSLog(@"%@", error);
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Authorizaton Context Providing

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return [[self view] window];
}

@end
