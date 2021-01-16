//
//  ETKeychainItem.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import <Foundation/Foundation.h>
#import "ETAppError.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETKeychainItem : NSObject

- (instancetype)initWithServiceString:(NSString *)service accountString:(NSString *)account;
@property NSString *service;
@property NSString *account;

- (NSString * _Nullable)stringByReadingItemValueWithError:(NSError * _Nullable * _Nullable)errorPointer;
- (NSData * _Nullable)dataByReadingItemValueWithError:(NSError * _Nullable * _Nullable)errorPointer;
- (BOOL)setItemValueWithItemData:(NSData *)itemData error:(NSError * _Nullable * _Nullable)errorPointer;
- (BOOL)setItemValueWithItemString:(NSString *)item error:(NSError * _Nullable * _Nullable)errorPointer;
- (BOOL)deleteItemValueWithError:(NSError * _Nullable * _Nullable)errorPointer;

@end

NS_ASSUME_NONNULL_END
