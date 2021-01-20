//
//  ETExpenseItemManagerTests.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import <XCTest/XCTest.h>

#import "ETExpenseItemManager.h"
#import "ETItemServerMock.h"

@interface ETExpenseItemManagerTests : XCTestCase

@end

@implementation ETExpenseItemManagerTests

- (void)test_refreshExpenseItemsWithCorrectResponse_thatExpenseItemsSetProperly {
    // setup
    NSDictionary *responseData = [self dictionaryForRefresh];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:responseData error:nil];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut refreshExpenseItemsWithCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
    
    // make sure equal item in sut's expense item list is equal to what we expect
    for (int i = 0; i < sut.expenseItemList.count; ++i) {
        // get ith expense item from response and from sut's expense item list
        NSDictionary *itemFromResponse = [[responseData objectForKey:@"expenseItems"] objectAtIndex:i];
        ETExpenseItem *item = [sut.expenseItemList objectAtIndex:i];
        
        NSLog(@"%@ - %@", itemFromResponse, [item toDictionary]);
        
        BOOL isItemsEqual = [[item toDictionary] isEqualToDictionary:itemFromResponse];
        XCTAssert(isItemsEqual);
    }
}

- (NSDictionary *)dictionaryForRefresh {
    return @{
        @"expenseItems": @[
            @{
                @"itemId": @"randomId1",
                @"amountInCents": @500,
                @"expenseTitle": @"lorem",
                @"expenseDescription": @"ipsum",
                @"dateOfPurchase": @1611165665,
                @"dateCreated": @1611165665
            },
            @{
                @"itemId": @"randomId2",
                @"amountInCents": @700,
                @"expenseTitle": @"dolor",
                @"expenseDescription": @"consectetur adipiscing elit",
                @"dateOfPurchase": @1611165665,
                @"dateCreated": @1611165665
            }
        ]
    };
}

@end
