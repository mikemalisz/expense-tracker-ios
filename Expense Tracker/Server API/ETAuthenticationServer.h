//
//  ETAuthenticationServer.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ETAuthenticationServer

- (void)authenticateWithPostData:(NSData *)postData completionHandler:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))onCompletion;

@end

NS_ASSUME_NONNULL_END
