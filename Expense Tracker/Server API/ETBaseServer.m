//
//  ETBaseServer.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import "ETBaseServer.h"

NSInteger const ETHTTPStatusOKCode = 200;

@interface ETBaseServer ()

@property id<ETNetworkSession> networkSession;

@end

@implementation ETBaseServer

#pragma mark - Initialization

- (instancetype)initWithNetworkSession:(id<ETNetworkSession>)networkSession {
    self = [super init];
    if (self) {
        _networkSession = networkSession;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkSession = [NSURLSession sharedSession];
    }
    return self;
}

#pragma mark - Intents

- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(ServerCompletionHandler)onCompletion {
    typeof(self) __weak weakSelf = self;
    [self.networkSession
     performDataTaskWithRequest:request
     completionHandler:^(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf dataTaskCompletionHandler:data response:response error:error completionHandler:onCompletion];
    }];
}

/// Generic data task completion handler
- (void)dataTaskCompletionHandler:(NSData * _Nullable)taskData response:(NSHTTPURLResponse * _Nullable)taskResponse error:(NSError * _Nullable)taskError completionHandler:(ServerCompletionHandler)onCompletion {
    if (taskError != nil) {
        onCompletion(nil, taskError);
    } else if ([(NSHTTPURLResponse *)taskResponse statusCode] != ETHTTPStatusOKCode) {
        // task data should contain some type of error dictionary
        NSDictionary *errorDetails = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:nil];
        
        ETAppError *serverResponseError;
        if (errorDetails && [errorDetails objectForKey:@"errorMessage"]) {
            serverResponseError = [ETAppError appErrorWithErrorMessage:[errorDetails objectForKey:@"errorMessage"]];
        } else {
            serverResponseError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
        }
        
        onCompletion(nil, serverResponseError);
    } else if (taskData != nil) {
        // received task data successfully
        NSError *error;
        NSDictionary *jsonData = [NSDictionary new];
        if ([taskData length] > 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
        }
        
        // json data should be populated if successful, otherwise error should exist
        onCompletion(jsonData, error);
    }
}

- (NSMutableURLRequest *)generateRequestWithPath:(NSString * _Nullable)path {
    NSMutableString *URLString = [[ETEnvironment serverURL] mutableCopy];
    if (path != nil) {
        [URLString appendString:path];
    }
    
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    return newRequest;
}

@end
