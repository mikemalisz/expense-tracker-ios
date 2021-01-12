//
//  ETMockServerAPI.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/11/21.
//

#import "ETMockServerAPI.h"

@implementation ETMockServerAPI

- (void)getExpenses:(nonnull void (^)(void))onCompletion {
    // 1. load mock-data
    // 2. parse it into array of Expense Items
    NSLog(@"%@", [[NSFileManager defaultManager] currentDirectoryPath]);
}
@end
