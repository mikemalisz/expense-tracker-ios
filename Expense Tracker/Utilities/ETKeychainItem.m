//
//  ETKeychainItem.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETKeychainItem.h"

@implementation ETKeychainItem
- (instancetype)initWithServiceString:(NSString *)service accountString:(NSString *)account {
    self = [super init];
    if (self) {
        _service = service;
        _account = account;
    }
    return self;
}

- (NSString * _Nullable)readItemValue {
    return nil;
}

- (BOOL)setItemValueWithItemString:(NSString *)item error:(NSError * _Nullable * _Nullable)errorPointer {
    
    NSData *encodedItem = [item dataUsingEncoding:NSUTF8StringEncoding];
    if (encodedItem != nil) {
        [self setItemValueWithItemData:encodedItem];
        return YES;
    } else if (errorPointer) {
        // couldn't convert item to data, update error object
        *errorPointer = [ETAppError initWithErrorCode:ETDataConversionFailureErrorCode];
    }
    return NO;
}

- (BOOL)setItemValueWithItemData:(NSData *)item {
    
}

@end
