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

#pragma mark Refresh Item Tests

- (void)test_refreshExpenseItemsWithCorrectResponse_thatExpenseItemsSetProperly {
    // setup
    NSDictionary *responseData = [self dictionaryForRefresh];
    NSArray *expenseItemsDictionaries = [responseData objectForKey:@"expenseItems"];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:responseData error:nil];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut refreshExpenseItemsWithCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
    
    [self
     assertExpenseItemListIsEqualToReference:sut.expenseItemList
     reference:expenseItemsDictionaries];
}

- (void)test_refreshExpenseItemWithErrorResponse_thatErrorActionBlockExecutes {
    ETAppError *testError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:nil error:testError];
    
    // sut creation & setup
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut refreshExpenseItemsWithCompletionHandler:^(NSError * _Nullable error) {
        XCTAssert([error isEqual:testError]);
    }];
    
    // No expense items should be set
    XCTAssert(sut.expenseItemList.count == 0);
}

#pragma mark Submit New Item Tests

- (void)test_submitExpenseItem_thatDataSentToServerIsCorrect {
    // input setup
    NSString *title = @"test title";
    NSString *description = @"description of an expense";
    NSString *dollarAmount = @"543.24";
    NSDate *datePurchased = [NSDate new];

    // result setup
    // convert our date to a milliseconds EPOCH timestamp
    NSTimeInterval purchasedInterval = round(datePurchased.timeIntervalSince1970 * 1000);
    NSDictionary *expectedDictionary = [self
                                        dictionaryForServerWithItemId:nil
                                        title:title
                                        description:description
                                        amountInCents:@54324
                                        purchaseTimestamp:[NSNumber numberWithDouble:purchasedInterval]
                                        createdTimestamp:nil];
    
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:nil error:nil];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    // server mock will intercept the data it's called with from the item manager
    // and call this block to let us check the data is formatted correctly
    [serverMock setOnPersistItemActionWithProvidedData:^(NSData *submittedData) {
        NSError *error;
        NSDictionary *submittedDictionary = [NSJSONSerialization JSONObjectWithData:submittedData options:0 error:&error];
        
        // error should be nil
        XCTAssertNil(error);
        // dictionary should contain our inputted parameters, formatted
        // to the way the backend is expecting it
        XCTAssert([submittedDictionary isEqualToDictionary:expectedDictionary]);
    }];
    
    [sut submitNewExpenseItemWithTitle:title description:description dollarAmount:dollarAmount datePurchased:datePurchased completionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)test_submitExpenseItemWithCorrectResponse_thatExpenseItemsSetProperly {
    // setup
    NSDictionary *responseData = [self dictionaryForRefresh];
    NSArray *expenseItemsDictionaries = [responseData objectForKey:@"expenseItems"];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:responseData error:nil];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut
     submitNewExpenseItemWithTitle:[NSString new]
     description:[NSString new]
     dollarAmount:[NSString new]
     datePurchased:[NSDate new]
     completionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
    
    [self
     assertExpenseItemListIsEqualToReference:sut.expenseItemList
     reference:expenseItemsDictionaries];
}

- (void)test_submitExpenseItemWithErrorResponse_thatErrorActionBlockExecutes {
    ETAppError *testError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:nil error:testError];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut
     submitNewExpenseItemWithTitle:[NSString new]
     description:[NSString new]
     dollarAmount:[NSString new]
     datePurchased:[NSDate new]
     completionHandler:^(NSError * _Nullable error) {
        XCTAssert([error isEqual:testError]);
    }];
    
    // No expense items should be set
    XCTAssert(sut.expenseItemList.count == 0);
}

#pragma mark Delete Item Tests

- (void)test_deleteExpenseItem_thatDataSentToServerIsCorrect {
    // input setup
    NSString *itemIdToDelete = [NSUUID new].UUIDString;

    // result setup
    // convert our date to a milliseconds EPOCH timestamp
    NSDictionary *expectedDictionary = [self
                                        dictionaryForServerWithItemId:itemIdToDelete
                                        title:nil
                                        description:nil
                                        amountInCents:nil
                                        purchaseTimestamp:nil
                                        createdTimestamp:nil];
    
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:nil error:nil];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    // server mock will intercept the data it's called with from the item manager
    // and call this block to let us check the data is formatted correctly
    [serverMock setOnPersistItemActionWithProvidedData:^(NSData *submittedData) {
        NSError *error;
        NSDictionary *submittedDictionary = [NSJSONSerialization JSONObjectWithData:submittedData options:0 error:&error];
        
        // error should be nil
        XCTAssertNil(error);
        // dictionary should contain our inputted parameters, formatted
        // to the way the backend is expecting it
        XCTAssert([submittedDictionary isEqualToDictionary:expectedDictionary]);
    }];
    
    [sut deleteExpenseItemWithItemId:itemIdToDelete completionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)test_deleteExpenseItemWithCorrectResponse_thatExpenseItemsSetProperly {
    // setup
    NSDictionary *responseData = [self dictionaryForRefresh];
    NSArray *expenseItemsDictionaries = [responseData objectForKey:@"expenseItems"];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:responseData error:nil];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut
     deleteExpenseItemWithItemId:[NSString new]
     completionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
    
    [self
     assertExpenseItemListIsEqualToReference:sut.expenseItemList
     reference:expenseItemsDictionaries];
}

- (void)test_deleteExpenseItemWithErrorResponse_thatErrorActionBlockExecutes {
    ETAppError *testError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
    ETItemServerMock *serverMock = [ETItemServerMock itemServerMockWithCompletionHandlerData:nil error:testError];
    
    // sut creation
    ETExpenseItemManager *sut = [[ETExpenseItemManager alloc] initWithServerAPI:serverMock];
    
    // testing
    [sut
     deleteExpenseItemWithItemId:[NSString new]
     completionHandler:^(NSError * _Nullable error) {
        XCTAssert([error isEqual:testError]);
    }];
    
    // No expense items should be set
    XCTAssert(sut.expenseItemList.count == 0);
}

#pragma mark Retrieve Total Spend Tests

#pragma mark - Convenience

- (NSDictionary *)dictionaryForRefresh {
    return @{
        @"expenseItems": @[
            @{
                ETExpenseItemIdentifierKey: @"randomId1",
                ETExpenseItemAmountInCentsKey: @549,
                ETExpenseItemExpenseTitleKey: @"lorem",
                ETExpenseItemExpenseDescriptionKey: @"ipsum",
                ETExpenseItemDateOfPurchaseKey: @1611165665,
                ETExpenseItemDateCreatedKey: @1611165665
            },
            @{
                ETExpenseItemIdentifierKey: @"randomId2",
                ETExpenseItemAmountInCentsKey: @721,
                ETExpenseItemExpenseTitleKey: @"dolor",
                ETExpenseItemExpenseDescriptionKey: @"consectetur adipiscing elit",
                ETExpenseItemDateOfPurchaseKey: @1611165665,
                ETExpenseItemDateCreatedKey: @1611165665
            }
        ]
    };
}

- (NSDictionary *)dictionaryForServerWithItemId:(NSString * _Nullable)itemId
                                          title:(NSString * _Nullable)title
                                    description:(NSString * _Nullable)description
                                  amountInCents:(NSNumber * _Nullable)amountInCents
                              purchaseTimestamp:(NSNumber * _Nullable)purchaseTimestamp
                               createdTimestamp:(NSNumber * _Nullable)createdTimestamp {
    NSMutableDictionary *serverData = [NSMutableDictionary new];
    if (itemId != nil) {
        [serverData setObject:itemId forKey:ETExpenseItemIdentifierKey];
    }
    if (title != nil) {
        [serverData setObject:title forKey:ETExpenseItemExpenseTitleKey];
    }
    if (description != nil) {
        [serverData setObject:description forKey:ETExpenseItemExpenseDescriptionKey];
    }
    if (amountInCents != nil) {
        [serverData setObject:amountInCents forKey:ETExpenseItemAmountInCentsKey];
    }
    if (purchaseTimestamp != nil) {
        [serverData setObject:purchaseTimestamp forKey:ETExpenseItemDateOfPurchaseKey];
    }
    if (createdTimestamp != nil) {
        [serverData setObject:createdTimestamp forKey:ETExpenseItemDateCreatedKey];
    }
    return serverData;
}

- (void)assertExpenseItemListIsEqualToReference:(NSArray<ETExpenseItem *> *)expenseItemList reference:(NSArray<NSDictionary *> *)reference {
    // number of expense items should be equal between input list and reference item count
    XCTAssert(expenseItemList.count == reference.count);
    
    // make sure each list expense item is equal to each item in reference
    for (int i = 0; i < expenseItemList.count; ++i) {
        // get ith expense item from response and from sut's expense item list
        NSDictionary *itemFromResponse = [reference objectAtIndex:i];
        ETExpenseItem *item = [expenseItemList objectAtIndex:i];
        
        BOOL isItemsEqual = [[item toDictionary] isEqualToDictionary:itemFromResponse];
        XCTAssert(isItemsEqual);
    }
}

@end
