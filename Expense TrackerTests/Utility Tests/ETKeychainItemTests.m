//
//  ETKeychainItemTests.m
//  Expense TrackerTests
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import <XCTest/XCTest.h>

#import "ETKeychainItem.h"

NSString *const ETKeychainServiceString = @"test-service";
NSString *const ETKeychainAccountString = @"test-account";

@interface ETKeychainItemTests : XCTestCase

@property ETKeychainItem *sut;

@end

@implementation ETKeychainItemTests

#pragma mark - Test Preparation

- (void)setUp {
    // create new keychain item instance for each test that runs
    ETKeychainItem *item = [[ETKeychainItem alloc] initWithServiceString:ETKeychainServiceString accountString:ETKeychainAccountString];
    [self setSut:item];
}

- (BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    return [[self sut] deleteItemValueWithError:error];
}

#pragma mark - Tests

- (void)test_whenInitializing_thatObjectInitializedProperly {
    ETKeychainItem *sut = [self sut];
    
    XCTAssert([[sut service] isEqualToString:ETKeychainServiceString]);
    XCTAssert([[sut account] isEqualToString:ETKeychainAccountString]);
}

- (void)test_readItemWithNoValueSet_thatNoItemIsReturned {
    ETKeychainItem *sut = [self sut];
    
    NSError *testError;
    NSString *storedValue = [sut stringByReadingItemValueWithError:&testError];
    
    XCTAssertNil(storedValue);
    XCTAssert(testError);
}

- (void)test_setAndReadStringItem_thatItemIsSavedAndReadProperly {
    // setup
    NSString *passwordToSave = @"Random password";
    NSError *error;
    ETKeychainItem *sut = [self sut];
    
    // set item - should save without errors
    BOOL isSuccessful = [sut setItemValueWithItemString:passwordToSave error:&error];
    
    XCTAssert(isSuccessful);
    XCTAssertNil(error);
    
    // read item - should return our password without errors
    NSString *retrievedPassword = [sut stringByReadingItemValueWithError:&error];
    
    XCTAssert([passwordToSave isEqualToString:retrievedPassword]);
    XCTAssertNil(error);
}

- (void)test_setAndReadDictionaryItem_thatItemIsSavedAndReadProperly {
    // setup
    NSDictionary *testDictionary = @{ @"testKey": @"value", @"secondKey": @10 };
    NSData *encodedDictionary = [NSJSONSerialization dataWithJSONObject:testDictionary options:0 error:nil];
    
    NSError *error;
    ETKeychainItem *sut = [self sut];
    
    // set item - should save without errors
    BOOL isSuccessful = [sut setItemValueWithItemData:encodedDictionary error:&error];
    
    XCTAssert(isSuccessful);
    XCTAssertNil(error);
    
    // read item - should return our password without errors
    NSData *retrievedData = [sut dataByReadingItemValueWithError:&error];
    NSMutableDictionary *deserializedDictionary = [NSJSONSerialization JSONObjectWithData:retrievedData options:0 error:nil];
    
    XCTAssert([testDictionary isEqualToDictionary:deserializedDictionary]);
    XCTAssertNil(error);
}

- (void)test_setAndOverwriteItem_thatItemIsOverwrittenProperly {
    // setup
    NSString *firstPassword = @"Random password";
    NSString *secondPassword = @"Overwriting password";
    NSError *error;
    ETKeychainItem *sut = [self sut];
    
    // set item once
    [sut setItemValueWithItemString:firstPassword error:nil];
    
    // overwrite existing item
    BOOL isSuccessful = [sut setItemValueWithItemString:secondPassword error:&error];
    
    XCTAssert(isSuccessful);
    XCTAssertNil(error);
    
    // read item - should return our second password without errors
    NSString *retrievedPassword = [sut stringByReadingItemValueWithError:&error];
    
    XCTAssert([secondPassword isEqualToString:retrievedPassword]);
    XCTAssertNil(error);
}

- (void)test_setAndDeleteItem_thatItemIsDeletedProperly {
    // setup
    NSString *firstPassword = @"Random password";
    NSError *error;
    ETKeychainItem *sut = [self sut];
    
    // set item
    [sut setItemValueWithItemString:firstPassword error:nil];
    
    // delete existing item
    BOOL isSuccessful = [sut deleteItemValueWithError:&error];
    
    XCTAssert(isSuccessful);
    XCTAssertNil(error);
}

- (void)test_deleteNonexistantItem_thatReturnsSuccessfully {
    // setup
    NSError *error;
    ETKeychainItem *sut = [self sut];
    
    // delete non existant item
    BOOL isSuccessful = [sut deleteItemValueWithError:&error];
    
    XCTAssert(isSuccessful);
    XCTAssertNil(error);
}

@end
