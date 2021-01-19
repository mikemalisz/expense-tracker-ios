//
//  ETNetworkSessionMock.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "ETNetworkSessionMock.h"

@interface ETNetworkSessionMock ()

@property NSData *data;
@property NSHTTPURLResponse *response;
@property NSError *error;

@end

@implementation ETNetworkSessionMock

+ (ETNetworkSessionMock *)networkSessionMockUsingData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error {
    ETNetworkSessionMock *mock = [ETNetworkSessionMock new];
    [mock setData:data];
    [mock setResponse:response];
    [mock setError:error];
    return mock;
}

- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSHTTPURLResponse * _Nullable, NSError * _Nullable))onCompletion {
    if (self.didPerformTaskActionWithRequest) {
        self.didPerformTaskActionWithRequest(request);
    }
    onCompletion(self.data, self.response, self.error);
}

@end
