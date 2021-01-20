//
//  ETAuthenticationServerMock.h
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import <Foundation/Foundation.h>
#import "ETAuthenticationServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETAuthenticationServerMock : NSObject <ETAuthenticationServer>

+ (ETAuthenticationServerMock *)authenticationServerMockWithCompletionHandlerData:(NSDictionary * _Nullable)data error:(NSError * _Nullable)error;

@property (nullable) NSDictionary *completionHandlerData;
@property (nullable) NSError *completionHandlerError;

@property (nullable) void (^onAuthenticateActionWithProvidedData)(NSData *);

@end

NS_ASSUME_NONNULL_END
