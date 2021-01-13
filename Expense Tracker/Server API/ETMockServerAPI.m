//
//  ETMockServerAPI.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/11/21.
//

#import "ETMockServerAPI.h"

NSString *const mockDataFilename = @"mock-data";

@implementation ETMockServerAPI

- (instancetype)init {
	self = [super init];
	if (self) {
		[self saveBundleMockDataToDocuments];
	}
	return self;
}

/// saves the mock expenses j
- (void)saveBundleMockDataToDocuments {
	NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"mock-expenses" ofType:@".json"];
	NSURL *localFilePath = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
	[[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:[localFilePath path] error:nil];
}

- (void)retrieveExpenseItems:(nonnull void (^)(NSArray<ETExpenseItem*>*, NSError*))onCompletion {
	NSArray<ETExpenseItem *> *expenseItemList = [self readDataFromMockDataFile];
    onCompletion(expenseItemList, nil);
}

- (void)persistNewExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nonnull))onCompletion {
	
}


- (void)deleteExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nonnull))onCompletion {
	
}


- (void)updateExistingExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nonnull))onCompletion {
	
}

#pragma mark - File IO

- (NSArray<ETExpenseItem *> *)readDataFromMockDataFile {
	// retrieve the dictionary data from the mock data file in the user's documents directory
	NSURL *fileUrl = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
	NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[fileUrl path]];
	NSArray<NSDictionary *> *dictionaryList = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
	return [self createExpenseItemsFromDictionaryList:dictionaryList];
}

- (void)writeDataToMockDataFileWithExpenseItems:(NSArray<ETExpenseItem*>*)expenseItemList {
	// convert expense items into dictionary format
	NSMutableArray *expenseItemDictionaryList = [NSMutableArray new];
	for (ETExpenseItem *item in expenseItemList) {
		[expenseItemDictionaryList addObject:[item toDictionary]];
	}

	// write the expense item dictionary list to the mock data file
	NSURL *fileUrl = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
	NSData *serializedData = [NSJSONSerialization dataWithJSONObject:expenseItemDictionaryList options:0 error:nil];
	BOOL didComplete = [serializedData writeToURL:fileUrl atomically:YES];
	NSLog(@"%c", didComplete);
}

#pragma mark - Data Preparation

- (NSArray<ETExpenseItem *> *)createExpenseItemsFromDictionaryList:(NSArray<NSDictionary *> *)dictionaryList {
	// configure our date formatter
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
	
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
