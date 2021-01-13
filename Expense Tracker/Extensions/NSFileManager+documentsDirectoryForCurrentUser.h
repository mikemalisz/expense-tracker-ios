//
//  NSFileManager+documentsDirectoryForCurrentUser.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ETExtension)
+ (NSURL*)documentsDirectoryForCurrentUser;
@end

NS_ASSUME_NONNULL_END
