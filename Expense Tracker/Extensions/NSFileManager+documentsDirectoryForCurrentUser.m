//
//  NSFileManager+documentsDirectoryForCurrentUser.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "NSFileManager+documentsDirectoryForCurrentUser.h"

@implementation NSFileManager (ETExtension)
+ (NSURL*)documentsDirectoryForCurrentUser {
	NSArray<NSURL*> *possibleUrls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	return [possibleUrls lastObject];
}
@end
