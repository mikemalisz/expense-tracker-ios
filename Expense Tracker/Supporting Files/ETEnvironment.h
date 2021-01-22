//
//  ETEnvironment.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/21/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Provides easy access to environment variables
@interface ETEnvironment : NSObject
+ (NSString *)appMode;
+ (NSString *)serverURL;
@end

NS_ASSUME_NONNULL_END
