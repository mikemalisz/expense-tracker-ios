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
    // app error codes should start at 0 and go up to ETAppErrorCodeCount
    for (int errorCode = 0; errorCode < ETAppErrorCodeCount; ++errorCode) {
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

