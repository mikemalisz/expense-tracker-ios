//
//  ETMockServerAPI.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/11/21.
//

#import "ETMockServerAPI.h"

NSString *const mockDataFilename = @"mock-data";

@implementation ETMockServerAPI

- (void)retrieveExpenseItems:(nonnull void (^)(NSArray<ETExpenseItem*>*, NSError * _Nullable))onCompletion {
	NSArray<ETExpenseItem *> *expenseItemList = [self readDataFromMockDataFile];
    onCompletion(expenseItemList, nil);
}

- (void)persistNewExpenseItem:(ETExpenseItem *)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion {
	NSMutableArray *expenseItemList = [[self readDataFromMockDataFile] mutableCopy];
	[expenseItemList addObject:expenseItem];
	[self writeDataToMockDataFileWithExpenseItems:[expenseItemList copy]];
	onCompletion(nil);
}


- (void)deleteExpenseItem:(ETExpenseItem *)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion {
	NSMutableArray *expenseItemList = [[self readDataFromMockDataFile] mutableCopy];
	NSUInteger index = [expenseItemList indexOfObjectPassingTest:^BOOL(ETExpenseItem *obj, NSUInteger idx, BOOL *stop) {
		return obj.identifier == expenseItem.identifier;
	}];
	if (index != NSNotFound) {
		[expenseItemList removeObjectAtIndex:index];
	}
	[self writeDataToMockDataFileWithExpenseItems:[expenseItemList copy]];
	onCompletion(nil);
}


- (void)updateExistingExpenseItem:(ETExpenseItem *)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion {
	NSMutableArray *expenseItemList = [[self readDataFromMockDataFile] mutableCopy];
	NSUInteger index = [expenseItemList indexOfObjectPassingTest:^BOOL(ETExpenseItem *obj, NSUInteger idx, BOOL *stop) {
		return obj.identifier == expenseItem.identifier;
	}];
	if (index != NSNotFound) {
		[expenseItemList replaceObjectAtIndex:index withObject:expenseItem];
	}
	[self writeDataToMockDataFileWithExpenseItems:[expenseItemList copy]];
}

#pragma mark - File IO

- (NSArray<ETExpenseItem *> *)readDataFromMockDataFile {
	// retrieve the dictionary data from the mock data file in the user's documents directory
	NSURL *fileUrl = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[fileUrl path]];
    if (fileData != nil) {
        // contents of mock data file exists
        NSArray<NSDictionary *> *dictionaryList = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
        return [self createExpenseItemsFromDictionaryList:dictionaryList];
    } else {
        // mock data file doesn't exist
        return [NSArray new];
    }
}

- (void)writeDataToMockDataFileWithExpenseItems:(NSArray<ETExpenseItem*>*)expenseItemList {
	// convert expense items into dictionary format
	NSMutableArray *expenseItemDictionaryList = [NSMutableArray new];
	for (ETExpenseItem *item in expenseItemList) {
		[expenseItemDictionaryList addObject:[item toDictionary]];
	}

	// write the expense item dictionary list to the mock data file
	NSURL *fileUrl = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
    if ([NSJSONSerialization isValidJSONObject:expenseItemDictionaryList]) {
        NSLog(@"valid json");
        NSData *serializedData = [NSJSONSerialization dataWithJSONObject:expenseItemDictionaryList options:0 error:nil];
        BOOL didComplete = [serializedData writeToURL:fileUrl atomically:YES];
        NSLog(@"%c", didComplete);
    } else {
        NSLog(@"invalid json");
    }
}

#pragma mark - Data Preparation

- (NSArray<ETExpenseItem *> *)createExpenseItemsFromDictionaryList:(NSArray<NSDictionary *> *)dictionaryList {
	// configure our date formatter
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
	
	// get ready to create new expense items and store them in this list
	NSMutableArray<ETExpenseItem *> *expenseItemList = [NSMutableArray new];
	
	// loop through each raw expense item in dictionary format, and
	// initialize an expense item from it
	for (NSDictionary *expenseItem in dictionaryList) {
		NSDate *dateOfPurchase = [formatter dateFromString:expenseItem[ETExpenseItemDateOfPurchaseKey]];
		NSDate *dateCreated = [formatter dateFromString:expenseItem[ETExpenseItemDateCreatedKey]];
		
		NSMutableDictionary *initializationItems = [expenseItem mutableCopy];
		[initializationItems setObject:dateOfPurchase forKey:ETExpenseItemDateOfPurchaseKey];
		[initializationItems setObject:dateCreated forKey:ETExpenseItemDateCreatedKey];
		
		ETExpenseItem *newExpenseItem = [[ETExpenseItem alloc] initWithDictionary:initializationItems];
		[expenseItemList addObject:newExpenseItem];
	}
	return expenseItemList;
}

@end
