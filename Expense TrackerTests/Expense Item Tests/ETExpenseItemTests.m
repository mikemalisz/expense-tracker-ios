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
    NSDictionary *newDictionary = [self initializationDictionary];
    
    // acquire our variables for comparison and assertion
    NSString *identifier = newDictionary[ETExpenseItemIdentifierKey];
    NSNumber *amountInCents = newDictionary[ETExpenseItemAmountInCentsKey];
    NSString *expenseTitle = newDictionary[ETExpenseItemExpenseTitleKey];
    NSString *expenseDescription = newDictionary[ETExpenseItemExpenseDescriptionKey];
    
    // dates require to be converted from timestamp to date object
    NSNumber *purchaseTimestamp = newDictionary[ETExpenseItemDateOfPurchaseKey];
    NSNumber *createdTimestamp = newDictionary[ETExpenseItemDateCreatedKey];
    
    // convert milliseconds to seconds
    NSTimeInterval purchaseInterval = purchaseTimestamp.doubleValue / 1000;
    NSTimeInterval createdInterval = createdTimestamp.doubleValue / 1000;
    NSDate *purchaseDate = [NSDate dateWithTimeIntervalSince1970:purchaseInterval];
    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:createdInterval];
    
    // create our SUT
    ETExpenseItem *sut = [[ETExpenseItem alloc] initWithDictionary:newDictionary];
    
    // testing
    XCTAssert([[sut identifier] isEqualToString:identifier]);
    XCTAssert(sut.amountInCents == amountInCents.integerValue);
    XCTAssert([sut.expenseTitle isEqualToString:expenseTitle]);
    XCTAssert([sut.expenseDescription isEqualToString:expenseDescription]);
    
    // expense item should automatically converts timestamp to date during initialization
    XCTAssert([sut.dateOfPurchase isEqualToDate:purchaseDate]);
    XCTAssert([sut.dateCreated isEqualToDate:createdDate]);
}

- (void)test_toDictionaryMethod_producesExpectedOutput {
    NSDictionary *newDictionary = [self initializationDictionary];
    
    ETExpenseItem *sut = [[ETExpenseItem alloc] initWithDictionary:newDictionary];
    
    // test
    NSDictionary *result = [sut toDictionary];
    XCTAssert([result isEqualToDictionary:newDictionary]);
}

#pragma mark - Convenience Methods

- (NSDictionary *)initializationDictionary {
    NSString *identifier = @"random-id";
    NSNumber *amountInCents = @500;
    NSString *title = @"title";
    NSString *description = @"random description";
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timestamp = round(currentDate.timeIntervalSince1970 * 1000);
    NSNumber *dateOfPurchase = [NSNumber numberWithDouble:timestamp];
    NSNumber *dateCreated = [NSNumber numberWithDouble:timestamp];
    
    return @{
        ETExpenseItemIdentifierKey: identifier,
        ETExpenseItemAmountInCentsKey: amountInCents,
        ETExpenseItemExpenseTitleKey: title,
        ETExpenseItemExpenseDescriptionKey: description,
        ETExpenseItemDateOfPurchaseKey: dateOfPurchase,
        ETExpenseItemDateCreatedKey: dateCreated};
}

@end
