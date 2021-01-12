//
//  ETExpenseItemTests.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/10/21.
//

#import <XCTest/XCTest.h>

#import "ETExpenseItem.h"

@interface ETExpenseItemTests : XCTestCase

@end

@implementation ETExpenseItemTests

- (void)test_whenInitializing_withEmptyDictionary_thatObjectDoesntExist {
    NSDictionary *newDictionary = [NSDictionary new];
    ETExpenseItem *sut = [[ETExpenseItem alloc] initWithDictionary:newDictionary];
    
    XCTAssertNil(sut);
}

- (void)test_whenInitializing_withCorrectDictionary_thatObjectInitializedCorrectly {
    NSString *identifier = @"random-id";
    NSNumber *amountInCents = @500;
    NSString *title = @"title";
    NSString *description = @"random description";
    NSDate *dateOfPurchase = [NSDate date];
    NSDate *dateCreated = [NSDate date];
    
    NSLog(@"%@", ETExpenseItemIdentifierKey);
    NSDictionary *newDictionary = @{
        ETExpenseItemIdentifierKey: identifier,
        ETExpenseItemAmountInCentsKey: amountInCents,
        ETExpenseItemExpenseTitleKey: title,
        ETExpenseItemExpenseDescriptionKey: description,
        ETExpenseItemDateOfPurchaseKey: dateOfPurchase,
        ETExpenseItemDateCreatedKey: dateCreated};
    
    ETExpenseItem *sut = [[ETExpenseItem alloc] initWithDictionary:newDictionary];
    
    XCTAssert([[sut identifier] isEqualToString:identifier]);
    XCTAssert(sut.amountInCents == [amountInCents integerValue]);
    XCTAssert([[sut expenseTitle] isEqualToString:title]);
    XCTAssert([[sut expenseDescription] isEqualToString:description]);
    XCTAssert([[sut dateOfPurchase] isEqualToDate:dateOfPurchase]);
    XCTAssert([[sut dateCreated] isEqualToDate:dateCreated]);
}

@end
