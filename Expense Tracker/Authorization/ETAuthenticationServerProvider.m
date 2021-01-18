//
//  ETAuthenticationServerProvider.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETAuthenticationServerProvider.h"

@implementation ETAuthenticationServerProvider

- (void)authenticateWithPostData:(NSData *)postData completionHandler:(ServerCompletionHandler)onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"auth/authenticate"];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

- (void)requestAuthenticationStatusWithCompletionHandler:(ServerCompletionHandler)onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"auth/status"];
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

- (void)deauthenticateFromServerWithCompletionHandler:(ServerCompletionHandler)onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"auth/logout"];
    [request setHTTPMethod:@"POST"];
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

@end
