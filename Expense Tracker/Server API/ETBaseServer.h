//
//  ETBaseServer.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import <Foundation/Foundation.h>
#import "ETServerCompletionHandler.h"
#import "ETAppError.h"
#import "ETNetworkSession.h"
#import "NSURLSession+ETNetworkSession.h"
#import "ETEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETBaseServer : NSObject

- (instancetype)initWithNetworkSession:(id<ETNetworkSession>)networkSession;

- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(ServerCompletionHandler)onCompletion;

- (void)dataTaskCompletionHandler:(NSData * _Nullable)taskData response:(NSURLResponse * _Nullable)taskResponse error:(NSError * _Nullable)taskError completionHandler:(ServerCompletionHandler)onCompletion;

- (NSMutableURLRequest *)generateRequestWithPath:(NSString * _Nullable)path;

@end

NS_ASSUME_NONNULL_END
