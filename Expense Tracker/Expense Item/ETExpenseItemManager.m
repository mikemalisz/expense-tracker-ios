//
//  ETExpenseItemManager.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/12/21.
//

#import "ETExpenseItemManager.h"

NSString *const ETExpenseItemManagerItemListKeyPath = @"expenseItemList";

@interface ETExpenseItemManager ()
@property (readwrite) NSArray<ETExpenseItem *> *expenseItemList;

@property id<ETItemServer> itemServer;
@end

@implementation ETExpenseItemManager
- (instancetype)initWithServerAPI:(id<ETItemServer>)networkService {
	self = [super init];
	if (self) {
		_itemServer = networkService;
	}
	return self;
}

- (NSInteger)retrieveTotalSpend {
    NSInteger totalSpend = 0;
    for (ETExpenseItem *item in [self expenseItemList]) {
        totalSpend += item.amountInCents;
    }
    return totalSpend;
}

- (void)refreshExpenseItemsWithCompletionHandler:(void (^)(NSError * _Nullable))onCompletion {
	typeof(self) __weak weakSelf = self;
    [self.itemServer retrieveExpenseItems:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (data) {
            [weakSelf setExpenseItemListFromData:data];
        }
        onCompletion(error);
    }];
}

- (void)setExpenseItemListFromData:(NSDictionary *)data {
    NSMutableArray *expenseItems = [NSMutableArray new];
    for (NSDictionary *itemData in [data objectForKey:@"expenseItems"]) {
        ETExpenseItem *newItem = [[ETExpenseItem alloc] initWithDictionary:itemData];
        if (newItem != nil) {
            [expenseItems addObject:newItem];
            
        }
    }
    [self setExpenseItemList:expenseItems];
}

- (void)submitNewExpenseItemWithTitle:(NSString *)title description:(NSString *)expenseDescription dollarAmount:(NSString *)amountText datePurchased:(NSDate *)datePurchased completionHandler:(void (^)(NSError * _Nullable))onCompletion {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    double dollarAmount = [[formatter numberFromString:amountText] doubleValue];
    NSNumber *amountInCents = [NSNumber numberWithInteger:round(dollarAmount * 100)];
    
    // convert to milliseconds for backend
    NSTimeInterval purchaseInterval = round(datePurchased.timeIntervalSince1970 * 1000);
    NSDictionary *newItem = @{
        ETExpenseItemAmountInCentsKey: amountInCents,
        ETExpenseItemExpenseTitleKey: title,
        ETExpenseItemDateOfPurchaseKey: [NSNumber numberWithDouble:purchaseInterval],
        ETExpenseItemExpenseDescriptionKey: expenseDescription};
    
    NSError *error;
    NSData *serializedItem = [NSJSONSerialization dataWithJSONObject:newItem options:0 error:&error];
    
    if (serializedItem == nil) {
        onCompletion([ETAppError appErrorWithErrorCode:ETDataConversionFailureErrorCode]);
        return;
    }
    
    typeof(self) __weak weakSelf = self;
    [self.itemServer persistNewExpenseItem:serializedItem completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (data) {
            [weakSelf setExpenseItemListFromData:data];
        }
        onCompletion(error);
    }];
}

- (void)deleteExpenseItemWithItemId:(NSString *)itemId completionHandler:(void (^)(NSError * _Nullable))onCompletion {
    
    NSDictionary *data = @{
        ETExpenseItemIdentifierKey: itemId
    };
    
    NSError *error;
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    
    if (serializedData == nil) {
        onCompletion([ETAppError appErrorWithErrorCode:ETDataConversionFailureErrorCode]);
        return;
    }
    
    typeof(self) __weak weakSelf = self;
    [self.itemServer deleteExpenseItem:serializedData completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (data) {
            [weakSelf setExpenseItemListFromData:data];
        }
        onCompletion(error);
    }];
}
@end
