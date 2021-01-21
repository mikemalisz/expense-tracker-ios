//
//  ETAuthenticationManagerTests.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/20/21.
//

#import <XCTest/XCTest.h>

#import "ETAuthenticationManager.h"
#import "ETAuthenticationServerMock.h"

@interface ETAuthenticationManagerTests : XCTestCase

@end

@implementation ETAuthenticationManagerTests

#pragma mark - Test Lifecycle

- (void)tearDown {
    // clear any user defaults value set from each test
    [NSUserDefaults.standardUserDefaults removeObjectForKey:ETAuthenticationStateStorageKey];
}

#pragma mark - Tests

#pragma mark Initialization

- (void)test_whenInitializing_thatAuthenticationStatusIsSetToPreviousState {
    // setup
    NSDictionary *responseData = @{
        @"isAuthenticated": [NSNumber numberWithUnsignedInteger:ETAuthenticated]};
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:responseData
                                              error:nil];
    
    // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];
    XCTAssert(sut.authenticationState == ETUnauthenticated);
    
    /*
     refreshing set authentication status to authenticated,
     complete testing done in Authentication Status tests
     */
    [sut refreshAuthenticationStatus];
    
    // create a new authentication manager to make sure status was persisted
    sut = [[ETAuthenticationManager alloc] initWithAuthenticationServer:mockServer];
    XCTAssert(sut.authenticationState == ETAuthenticated);
}

#pragma mark Authentication status

- (void)test_refreshAuthenticationStatusWithUnauthenticatedResponse_thatStateIsSetToUnauthenticated {
    // setup
    NSDictionary *responseData = @{
        @"isAuthenticated": [NSNumber numberWithUnsignedInteger:ETUnauthenticated]};
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:responseData
                                              error:nil];
    
    // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];
    [sut setHandleErrorAction:^(NSError *error) {
        XCTAssertNil(error);
    }];
    [sut refreshAuthenticationStatus];
    XCTAssert(sut.authenticationState == ETUnauthenticated);
}

- (void)test_refreshAuthenticationStatusWithAuthenticatedResponse_thatStateIsSetToAuthenticated {
    // setup
    NSDictionary *responseData = @{
        @"isAuthenticated": [NSNumber numberWithUnsignedInteger:ETAuthenticated]};
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:responseData
                                              error:nil];
    
    // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];
    [sut setHandleErrorAction:^(NSError *error) {
        XCTAssertNil(error);
    }];
    [sut refreshAuthenticationStatus];
    XCTAssert(sut.authenticationState == ETAuthenticated);
}

- (void)test_refreshAuthenticationStatusWithErrorResponse_thatErrorActionIsExecuted {
    // setup
    ETAppError *appError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:nil
                                              error:appError];
    
    // setup
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];
    
    BOOL __block didInvokeErrorAction = NO;
    [sut setHandleErrorAction:^(NSError *error) {
        didInvokeErrorAction = YES;
        XCTAssert([error isEqual:appError]);
    }];
    [sut refreshAuthenticationStatus];
    XCTAssert(didInvokeErrorAction);
}

#pragma mark Server Authentication

- (void)test_authenticateWithIdentityToken_thatDataSentToServerIsFormattedCorrectly {
    // setup
    NSString *identityToken = [NSUUID new].UUIDString;
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *expectedResponse = @{
        @"identityToken": identityToken,
        @"clientId": bundleId
    };
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:nil
                                              error:nil];
    
    // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];
    [mockServer setOnAuthenticateActionWithProvidedData:^(NSData *providedData) {
        // convert data to dictionary
        NSError *error;
        NSDictionary *dataForServer = [NSJSONSerialization JSONObjectWithData:providedData options:0 error:&error];
        
        XCTAssertNil(error);
        BOOL isServerDataFormattedCorrectly = [dataForServer isEqualToDictionary:expectedResponse];
        XCTAssert(isServerDataFormattedCorrectly);
    }];
    
    [sut authenticateWithIdentityToken:identityToken bundleId:bundleId];
}

- (void)test_authenticateWithIdentityTokenWithError_thatErrorActionIsExecuted {
    // setup
    ETAppError *appError = [ETAppError appErrorWithErrorCode:ETServerResponseErrorCode];
    ETAuthenticationServerMock *mockServer = [ETAuthenticationServerMock
                                              authenticationServerMockWithCompletionHandlerData:nil
                                              error:appError];
    
    // testing
    ETAuthenticationManager *sut = [[ETAuthenticationManager alloc]
                                    initWithAuthenticationServer:mockServer];
    
    BOOL __block didInvokeErrorAction = NO;
    [sut setHandleErrorAction:^(NSError *error) {
        didInvokeErrorAction = YES;
        XCTAssert([error isEqual:appError]);
    }];
    
    [sut authenticateWithIdentityToken:[NSString new] bundleId:[NSString new]];
    XCTAssert(didInvokeErrorAction);
}

@end
