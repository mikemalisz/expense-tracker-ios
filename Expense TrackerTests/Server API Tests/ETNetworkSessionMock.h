//
//  ETNetworkSessionMock.h
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import <Foundation/Foundation.h>
#import "ETNetworkSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETNetworkSessionMock : NSObject <ETNetworkSession>

+ (ETNetworkSessionMock *)networkSessionMockUsingData:(NSData * _Nullable)data response:(NSHTTPURLResponse * _Nullable)response error:(NSError * _Nullable)error;

@property (nullable) void (^didPerformTaskActionWithRequest)(NSURLRequest *request);

@end

NS_ASSUME_NONNULL_END
