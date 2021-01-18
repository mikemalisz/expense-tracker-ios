//
//  ETServerProvider.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETServerProvider.h"

NSInteger const ETHTTPStatusOKCode = 200;

@implementation ETServerProvider

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
    NSMutableURLRequest *request = [self generateRequestWithPath:@"auth/status"];
    [request setHTTPMethod:@"POST"];
    [self performDataTaskWithRequest:request completionHandler:onCompletion];
}

- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(ServerCompletionHandler)onCompletion {
    NSURLSession *session = [NSURLSession sharedSession];
    typeof(self) __weak weakSelf = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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

- (void)deleteExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nullable))onCompletion {
    
}

- (void)persistNewExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nullable))onCompletion {
    
}

- (void)retrieveExpenseItems:(nonnull void (^)(NSArray<ETExpenseItem *> * _Nonnull, NSError * _Nullable))onCompletion {
    
}

- (void)updateExistingExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nullable))onCompletion {
    
}

@end
