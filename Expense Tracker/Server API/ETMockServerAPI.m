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

- (void)saveBundleMockDataToDocuments {
	NSLog(@"saving bundle mock data to documents");
	// configure our date formatter
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
	
	// get raw data from the mock expenses json file
	NSString *mockExpensesPath = [[NSBundle mainBundle] pathForResource:@"mock-expenses" ofType:@".json"];
	NSData *fileData = [NSData dataWithContentsOfFile:mockExpensesPath];
	
	NSURL *mockDataFilePath = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
	
	NSError *copyError;
	[[NSFileManager defaultManager] copyItemAtPath:mockExpensesPath toPath:[mockDataFilePath path] error:&copyError];
	if (copyError != nil) {
		NSLog(@"%@", copyError);
	}
	
	NSArray<NSDictionary*> *dictionaryList = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
	
	// get ready to create new expense items and store them in this list
	NSMutableArray *expenseItemList = [NSMutableArray new];
	
	// loop through each raw expense item in dictionary format, and
	// initialize an expense item from it
	for (NSDictionary *expenseItem in dictionaryList) {
		NSDate *dateOfPurchase = [formatter dateFromString:expenseItem[ETExpenseItemDateOfPurchaseKey]];
		NSDate *dateCreated = [formatter dateFromString:expenseItem[ETExpenseItemDateCreatedKey]];
		NSDictionary *initializationItems = @{
			ETExpenseItemIdentifierKey: expenseItem[ETExpenseItemIdentifierKey],
			ETExpenseItemAmountInCentsKey: expenseItem[ETExpenseItemAmountInCentsKey],
			ETExpenseItemExpenseTitleKey: expenseItem[ETExpenseItemExpenseTitleKey],
			ETExpenseItemExpenseDescriptionKey: expenseItem[ETExpenseItemExpenseDescriptionKey],
			ETExpenseItemDateOfPurchaseKey: dateOfPurchase,
			ETExpenseItemDateCreatedKey: dateCreated};
		ETExpenseItem *newExpenseItem = [[ETExpenseItem alloc] initWithDictionary:initializationItems];
		[expenseItemList addObject:newExpenseItem];
	}
	
	
}

- (void)retrieveExpenseItems:(nonnull void (^)(NSArray<ETExpenseItem*>*, NSError*))onCompletion {
    // configure our date formatter
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    // get raw data from the mock expenses json file
	
    
    // get ready to create new expense items and store them in this list
    NSMutableArray *expenseItemList = [NSMutableArray new];
    
    // loop through each raw expense item in dictionary format, and
    // initialize an expense item from it
    for (NSDictionary *expenseItem in expenseItemList) {
        NSDate *dateOfPurchase = [formatter dateFromString:expenseItem[ETExpenseItemDateOfPurchaseKey]];
        NSDate *dateCreated = [formatter dateFromString:expenseItem[ETExpenseItemDateCreatedKey]];
        NSDictionary *initializationItems = @{
            ETExpenseItemIdentifierKey: expenseItem[ETExpenseItemIdentifierKey],
            ETExpenseItemAmountInCentsKey: expenseItem[ETExpenseItemAmountInCentsKey],
            ETExpenseItemExpenseTitleKey: expenseItem[ETExpenseItemExpenseTitleKey],
            ETExpenseItemExpenseDescriptionKey: expenseItem[ETExpenseItemExpenseDescriptionKey],
            ETExpenseItemDateOfPurchaseKey: dateOfPurchase,
            ETExpenseItemDateCreatedKey: dateCreated};
        ETExpenseItem *newExpenseItem = [[ETExpenseItem alloc] initWithDictionary:initializationItems];
        [expenseItemList addObject:newExpenseItem];
    }
    
    // call completion handler with a copied version of our expense item list
    onCompletion([expenseItemList copy], nil);
}

- (void)persistNewExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nonnull))onCompletion {
}


- (void)deleteExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nonnull))onCompletion {
	
}


- (void)updateExistingExpenseItem:(nonnull ETExpenseItem *)expenseItem completionHandler:(nonnull void (^)(NSError * _Nonnull))onCompletion {
	
}

@end

#pragma mark - file IO

@implementation ETMockServerAPI (FileIO)

- (NSArray<NSDictionary*>*)readDataFromMockDataFile {
	NSURL *fileUrl = [[NSFileManager documentsDirectoryForCurrentUser] URLByAppendingPathComponent:mockDataFilename];
	NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[fileUrl path]];
	NSArray<NSDictionary*> *dictionaryList = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
	return dictionaryList;
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

@end
