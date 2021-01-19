//
//  ETBaseServer.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETBaseServer.h"

NSInteger const ETHTTPStatusOKCode = 200;

@implementation ETBaseServer

- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(ServerCompletionHandler)onCompletion {
    NSURLSession *session = [NSURLSession sharedSession];
    typeof(self) __weak weakSelf = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf dataTaskCompletionHandler:data response:response error:error completionHandler:onCompletion];
    }];
    
    [task resume];
}

/// Generic data task completion handler
- (void)dataTaskCompletionHandler:(NSData * _Nullable)taskData response:(NSURLResponse * _Nullable)taskResponse error:(NSError * _Nullable)taskError completionHandler:(ServerCompletionHandler)onCompletion {
    if (taskError != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            onCompletion(nil, taskError);
        });
    } else if ([(NSHTTPURLResponse *)taskResponse statusCode] != ETHTTPStatusOKCode) {
        // task data should contain some type of error dictionary
        NSDictionary *errorDetails = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:nil];
        
        ETAppError *serverResponseError;
        if (errorDetails && [errorDetails objectForKey:@"errorMessage"]) {
            serverResponseError = [ETAppError appErrorWithErrorMessage:[errorDetails objectForKey:@"errorMessage"]];
        } else {
            serverResponseError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            onCompletion(nil, serverResponseError);
        });
    } else if (taskData != nil) {
        // received task data successfully
        NSError *error;
        NSDictionary *jsonData = [NSDictionary new];
        if ([taskData length] > 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
        }
        
        // json data should be populated if successful, otherwise error should exist
        dispatch_async(dispatch_get_main_queue(), ^{
            onCompletion(jsonData, error);
        });
    }
}

- (NSMutableURLRequest *)generateRequestWithPath:(NSString * _Nullable)path {
    NSMutableString *URLString = [NSMutableString stringWithString:@"http://192.168.1.27:3000/"];
    if (path != nil) {
        [URLString appendString:path];
    }
    
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    return newRequest;
}

@end
