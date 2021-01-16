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

- (NSString * _Nullable)readItemValueWithError:(NSError * _Nullable * _Nullable)errorPointer {
    NSMutableDictionary *query = [[self keychainQueryWithService:[self service] account:[self account]] mutableCopy];
    
    [query setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    SecKeyRef key = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&key);
    
    NSString *item;
    if (status == errSecSuccess) {
        // make sure password our key pointer contains the password data
        NSDictionary *passwordData = (__bridge NSDictionary *)key;
        if ((passwordData != nil) && [passwordData objectForKey:(id)kSecValueData] != nil) {
            item = [[NSString alloc] initWithData:[passwordData objectForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding];
        }
    } else if (errorPointer) {
        // Query was unsuccessful
        *errorPointer = [ETAppError appErrorWithErrorCode:ETGenericErrorCode];
    }
    
    // If the key exists, we have to free its memory!
    if (key) { CFRelease(key); }
    
    return item;
}

- (BOOL)setItemValueWithItemString:(NSString *)item error:(NSError * _Nullable * _Nullable)errorPointer {
    
    NSData *encodedItem = [item dataUsingEncoding:NSUTF8StringEncoding];
    if (encodedItem != nil) {
        return [self setItemValueWithItemData:encodedItem error:errorPointer];
    } else if (errorPointer) {
        // couldn't convert item to data, update error object
        *errorPointer = [ETAppError appErrorWithErrorCode:ETDataConversionFailureErrorCode];
    }
    return NO;
}

- (BOOL)setItemValueWithItemData:(NSData *)itemData error:(NSError * _Nullable * _Nullable)errorPointer {
    id storedItem = [self readItemValueWithError:nil];
    
    if (storedItem) {
        // item exists, perform update command for existing item
        NSDictionary *attributesToUpdate = @{ (id)kSecValueData: itemData };
        
        NSDictionary *query = [self keychainQueryWithService:[self service] account:[self account]];
        
        OSStatus status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
        
        if (status == errSecSuccess) {
            return YES;
        }
        
    } else {
        // item doesn't exist, add item to keychain
        NSMutableDictionary *newAttributes = [[self keychainQueryWithService:[self service] account:[self account]] mutableCopy];
        [newAttributes setObject:itemData forKey:(id)kSecValueData];
        
        OSStatus status = SecItemAdd((CFDictionaryRef)newAttributes, nil);
        
        if (status == errSecSuccess) {
            return YES;
        }
    }
    
    // If saving the item was successful, we should've exited before reaching this point.
    // set an error for the error pointer and return no for operation unsuccessful
    if (errorPointer) {
        *errorPointer = [ETAppError appErrorWithErrorCode:ETGenericErrorCode];
    }
    return NO;
}

- (BOOL)deleteItemValueWithError:(NSError * _Nullable * _Nullable)errorPointer {
    NSDictionary *queryToDelete = [self keychainQueryWithService:[self service] account:[self account]];
    
    OSStatus status = SecItemDelete((CFDictionaryRef)queryToDelete);
    
    // return truthy if successful or item not found, other falsey
    if ((status == errSecSuccess) || (status == errSecItemNotFound)) {
        return YES;
    } else if (errorPointer) {
        // set error if error pointer exists
        *errorPointer = [ETAppError appErrorWithErrorCode:ETGenericErrorCode];
    }
    return NO;
}

#pragma mark - Convenience

- (NSDictionary *)keychainQueryWithService:(NSString * _Nullable)service account:(NSString * _Nullable)account {
    NSMutableDictionary *query = [NSMutableDictionary new];
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    if (service) {
        [query setObject:service forKey:(id)kSecAttrService];
    }
    
    if (account) {
        [query setObject:account forKey:(id)kSecAttrAccount];
    }
    
    return [query copy];
}

@end
