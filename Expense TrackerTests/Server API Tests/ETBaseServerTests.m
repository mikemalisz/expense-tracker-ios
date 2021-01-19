//
//  ETBaseServerTests.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import <XCTest/XCTest.h>

#import "ETNetworkSessionMock.h"
#import "ETBaseServer.h"

#pragma mark - Properties

@interface ETBaseServerTests : XCTestCase

@end

#pragma mark - Methods

@implementation ETBaseServerTests

- (void)test_whenMockingNormalRequest_thatResponseDataIsCorrect {
    // setup
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:[self dictionaryFactory] options:0 error:nil];
    NSHTTPURLResponse *urlResponse = [self OK_HTTPURLResponse];
    ETNetworkSessionMock *mock = [ETNetworkSessionMock
                                  networkSessionMockUsingData:serializedData
                                  response:urlResponse
                                  error:nil];
    
    // test
    ETBaseServer *sut = [[ETBaseServer alloc] initWithNetworkSession:mock];
    [sut performDataTaskWithRequest:[NSURLRequest new] completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        XCTAssert([data isEqualToDictionary:[self dictionaryFactory]]);
        XCTAssertNil(error);
    }];
}

- (void)test_whenMockingInternalServerError_thatResponseContainsError {
    // setup
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:[self dictionaryFactory] options:0 error:nil];
    NSHTTPURLResponse *urlResponse = [self internalServerError_HTTPURLResponse];
    ETAppError *appError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
    
    ETNetworkSessionMock *mock = [ETNetworkSessionMock
                                  networkSessionMockUsingData:serializedData
                                  response:urlResponse
                                  error:appError];
    
    // test
    ETBaseServer *sut = [[ETBaseServer alloc] initWithNetworkSession:mock];
    [sut performDataTaskWithRequest:[NSURLRequest new] completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        XCTAssertNil(data);
        XCTAssert([error isEqual:appError]);
    }];
}

- (void)test_whenMockingInternalServerErrorWithNoProvidedError_thatResponseContainsError {
    // setup
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:[self dictionaryFactory] options:0 error:nil];
    NSHTTPURLResponse *urlResponse = [self internalServerError_HTTPURLResponse];
    
    ETNetworkSessionMock *mock = [ETNetworkSessionMock
                                  networkSessionMockUsingData:serializedData
                                  response:urlResponse
                                  error:nil];
    
    // test
    ETBaseServer *sut = [[ETBaseServer alloc] initWithNetworkSession:mock];
    [sut performDataTaskWithRequest:[NSURLRequest new] completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        XCTAssertNil(data);
        XCTAssertNotNil(error);
    }];
}

#pragma mark Factory methods

- (NSDictionary *)dictionaryFactory {
    return @{
        @"some-value": @"lorem",
        @"ipsum": @5
    };
}

- (NSHTTPURLResponse *)OK_HTTPURLResponse {
    return [[NSHTTPURLResponse alloc]
            initWithURL:[NSURL new]
            statusCode:200
            HTTPVersion:nil
            headerFields:nil];
}

- (NSHTTPURLResponse *)internalServerError_HTTPURLResponse {
    return [[NSHTTPURLResponse alloc]
            initWithURL:[NSURL new]
            statusCode:500
            HTTPVersion:nil
            headerFields:nil];
}

@end

