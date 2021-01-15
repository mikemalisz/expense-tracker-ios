//
//  ETServerProvider.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETServerProvider.h"

@implementation ETServerProvider
- (void)testServerConnection {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [self generateRequest];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Error: %@", error);
    }];
    
    [task resume];
}

- (NSURLRequest *)generateRequest {
    NSURLRequest *newRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/"]];
    return newRequest;
}
@end
