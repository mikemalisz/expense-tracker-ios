//
//  ETAppErrorTests.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import <XCTest/XCTest.h>

#import "ETAppError.h"

@interface ETAppErrorTests : XCTestCase

@end

@implementation ETAppErrorTests

- (void)test_whenInitializing_withGenericErrorCode_thatObjectInitializedProperly {
    ETAppError *sut = [ETAppError appErrorWithErrorCode:ETGenericErrorCode];
    
    XCTAssert(sut != nil);
    XCTAssert([[sut domain] isEqualToString:ETAppErrorDomain]);
    XCTAssert([sut code] == ETGenericErrorCode);
}

- (void)test_whenInitializing_withDataConversionErrorCode_thatObjectInitializedProperly {
    ETAppError *sut = [ETAppError appErrorWithErrorCode:ETDataConversionFailureErrorCode];
    
    XCTAssert(sut != nil);
    XCTAssert([[sut domain] isEqualToString:ETAppErrorDomain]);
    XCTAssert([sut code] == ETDataConversionFailureErrorCode);
}

- (void)test_whenInitializing_withErrorMessage_thatObjectInitializedProperly {
    NSString *errorMessage = @"A test error message";
    ETAppError *sut = [ETAppError appErrorWithErrorMessage:errorMessage];
    
    XCTAssert(sut != nil);
    XCTAssert([[sut domain] isEqualToString:ETAppErrorDomain]);
    XCTAssert([sut code] == ETGenericErrorCode);
    XCTAssert([[sut localizedDescription] isEqualToString:errorMessage]);
}

@end

