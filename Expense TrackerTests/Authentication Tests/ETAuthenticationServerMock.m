//
//  ETAuthenticationServerMock.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import "ETAuthenticationServerMock.h"

@implementation ETAuthenticationServerMock

- (void)authenticateWithPostData:(NSData *)postData completionHandler:(ServerCompletionHandler)onCompletion {
    if (self.onAuthenticateActionWithProvidedData) {
        self.onAuthenticateActionWithProvidedData(postData);
    }
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

- (void)deauthenticateFromServerWithCompletionHandler:(ServerCompletionHandler)onCompletion {
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

- (void)requestAuthenticationStatusWithCompletionHandler:(ServerCompletionHandler)onCompletion {
    onCompletion(self.completionHandlerData, self.completionHandlerError);
}

@end
