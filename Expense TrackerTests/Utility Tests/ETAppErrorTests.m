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

- (void)test_whenInitializing_withEnumeratedErrorCodes_thatObjectsInitializeProperly {
    // setup a C style array filled with all the error codes we want to test
    ETAppErrorCode allErrorCodes[] = {
        ETGenericErrorCode,
        ETDataConversionFailureErrorCode,
        ETServerResponseErrorCode
    };
    int numberOfErrorCodes = (sizeof(allErrorCodes)/sizeof(allErrorCodes[0]));
    
    // loop through each error code in allErrorCodes and test object initialization
    for (int errorCode = 0; errorCode < numberOfErrorCodes; ++errorCode) {
        ETAppError *sut = [ETAppError appErrorWithErrorCode:errorCode];
        
        XCTAssert(sut != nil);
        XCTAssert([[sut domain] isEqualToString:ETAppErrorDomain]);
        XCTAssert([sut code] == errorCode);
    }
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

