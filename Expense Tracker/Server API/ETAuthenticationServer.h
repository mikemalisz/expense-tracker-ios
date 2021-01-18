//
//  ETAuthenticationServer.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import <Foundation/Foundation.h>
#import "ETServerCompletionHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETAuthenticationServer

- (void)authenticateWithPostData:(NSData *)postData completionHandler:(ServerCompletionHandler)onCompletion;

- (void)requestAuthenticationStatusWithCompletionHandler:(ServerCompletionHandler)onCompletion;

@end

NS_ASSUME_NONNULL_END
