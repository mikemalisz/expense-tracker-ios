//
//  NSURLSession+ETNetworkSession.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "NSURLSession+ETNetworkSession.h"

@implementation NSURLSession (ETNetworkSession)

- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSHTTPURLResponse * _Nullable, NSError * _Nullable))onCompletion {
    NSURLSessionDataTask *task = [self
                                  dataTaskWithRequest:request
                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse;
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            httpResponse = (NSHTTPURLResponse *)response;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onCompletion(data, httpResponse, error);
        });
    }];
    [task resume];
}

@end
