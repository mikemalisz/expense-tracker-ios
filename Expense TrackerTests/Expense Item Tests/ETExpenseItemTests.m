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
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timestamp = currentDate.timeIntervalSince1970 * 1000;
    NSNumber *dateOfPurchase = [NSNumber numberWithDouble:timestamp];
    NSNumber *dateCreated = [NSNumber numberWithDouble:timestamp];
    
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
    
    // expense item should automatically converts timestamp to date during initialization
    XCTAssert([[sut dateOfPurchase] isEqualToDate:currentDate]);
    XCTAssert([[sut dateCreated] isEqualToDate:currentDate]);
}

@end
