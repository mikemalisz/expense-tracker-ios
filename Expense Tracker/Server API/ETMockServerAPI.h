//
//  ETMockServerAPI.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/11/21.
//

#import <Foundation/Foundation.h>
#import "ETServerAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETMockServerAPI : NSObject<ETServerAPI>
- (void)getExpenses:(void (^)(NSArray<ETExpenseItem *>*))onCompletion;
@end

NS_ASSUME_NONNULL_END
