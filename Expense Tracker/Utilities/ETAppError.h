//
//  ETAppError.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents this app's specific error domain
extern NSErrorDomain const ETAppErrorDomain;

/// Common error codes produced by the app
typedef NS_ENUM(NSUInteger, ETAppErrorCode) {
    ETDataConversionFailureErrorCode
};

@interface ETAppError : NSError
+ (ETAppError *)initWithErrorCode:(ETAppErrorCode)code;
@end

NS_ASSUME_NONNULL_END