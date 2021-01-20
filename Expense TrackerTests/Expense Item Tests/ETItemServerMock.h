//
//  ETItemServerMock.h
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import <Foundation/Foundation.h>
#import "ETItemServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETItemServerMock : NSObject <ETItemServer>

+ (ETItemServerMock *)itemServerMockWithCompletionHandlerData:(NSDictionary * _Nullable)data error:(NSError * _Nullable)error;

@property (nullable) NSDictionary *completionHandlerData;
@property (nullable) NSError *completionHandlerError;

@property (nullable) void (^onDeleteItemActionWithProvidedData)(NSData *);

@property (nullable) void (^onPersistItemActionWithProvidedData)(NSData *);

@property (nullable) void (^onUpdateItemActionWithProvidedData)(NSData *);

@end

NS_ASSUME_NONNULL_END
