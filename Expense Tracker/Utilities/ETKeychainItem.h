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

- (NSString * _Nullable)readItemValue;
- (BOOL)setItemValueWithItemData:(NSData *)item error:(NSError * _Nullable * _Nullable)errorPointer;
- (BOOL)setItemValueWithItemString:(NSString *)item error:(NSError * _Nullable * _Nullable)errorPointer;

@end

NS_ASSUME_NONNULL_END
