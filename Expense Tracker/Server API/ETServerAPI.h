//
//  ETServerAPI.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <Foundation/Foundation.h>
#import "ETExpenseItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETServerAPI <NSObject>
- (void)getExpenses:(void (^)(NSArray<ETExpenseItem*>*))onCompletion;
@end

NS_ASSUME_NONNULL_END
