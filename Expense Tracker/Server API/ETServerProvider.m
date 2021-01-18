//
//  ETServerProvider.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETServerProvider.h"

NSInteger const ETHTTPStatusOKCode = 200;

@implementation ETServerProvider

- (void)authenticateWithPostData:(NSData *)postData completionHandler:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))onCompletion {
    NSMutableURLRequest *request = [self generateRequestWithPath:@"auth/authenticate"];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    typeof(self) __weak weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf dataTaskCompletionHandler:data response:response error:error completionHandler:onCompletion];
    }];
    
    [task resume];
}

- (void)testServerConnection {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [self generateRequestWithPath:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Error: %@", error);
    }];
    
    [task resume];
}

- (void)testServerConnectionWithCompletionHandler:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))onCompletion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [self generateRequestWithPath:nil];
    
    typeof(self) __weak weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Completion handler");
        [weakSelf dataTaskCompletionHandler:data response:response error:error completionHandler:onCompletion];
    }];
    
    [task resume];
}

/// Generic data task completion handler
- (void)dataTaskCompletionHandler:(NSData * _Nullable)taskData response:(NSURLResponse * _Nullable)taskResponse error:(NSError * _Nullable)taskError completionHandler:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))onCompletion {
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
