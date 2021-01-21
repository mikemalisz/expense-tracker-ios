//
//  ETAuthenticationServerMock.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import "ETAuthenticationServerMock.h"

@implementation ETAuthenticationServerMock

+ (ETAuthenticationServerMock *)authenticationServerMockWithCompletionHandlerData:(NSDictionary * _Nullable)data error:(NSError * _Nullable)error {
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock new];
    [mockServer setCompletionHandlerData:data];
    [mockServer setCompletionHandlerError:error];
    return mockServer;
}

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
