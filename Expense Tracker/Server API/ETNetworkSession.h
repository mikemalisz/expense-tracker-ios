//
//  ETNetworkSession.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import <Foundation/Foundation.h>
#import "ETServerCompletionHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETNetworkSession <NSObject>
- (void)performDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSHTTPURLResponse * _Nullable, NSError * _Nullable))onCompletion;
@end

NS_ASSUME_NONNULL_END
