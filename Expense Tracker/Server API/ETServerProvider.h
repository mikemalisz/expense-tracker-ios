//
//  ETServerProvider.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import <Foundation/Foundation.h>
#import "ETServerAPI.h"
#import "ETAppError.h"
#import "ETAuthenticationServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETServerProvider : NSObject <ETAuthenticationServer>
- (void)testServerConnection;
- (void)testServerConnectionWithCompletionHandler:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))onCompletion;
@end

NS_ASSUME_NONNULL_END
