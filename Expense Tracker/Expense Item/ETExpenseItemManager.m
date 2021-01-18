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
        NSLog(@"%@", itemData);
        ETExpenseItem *newItem = [[ETExpenseItem alloc] initWithDictionary:itemData];
        if (newItem != nil) {
            [expenseItems addObject:newItem];
            
        }
    }
    [self setExpenseItemList:expenseItems];
    NSLog(@"%@", self.expenseItemList);
}

- (void)submitNewExpenseItemWithTitle:(NSString *)title description:(NSString *)expenseDescription dollarAmount:(NSString *)amountText datePurchased:(NSDate *)datePurchased completionHandler:(void (^)(NSError * _Nullable))onCompletion {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSInteger dollarAmount = [[formatter numberFromString:amountText] integerValue];
    NSNumber *amountInCents = [NSNumber numberWithInteger:(dollarAmount * 100)];
    
    NSDictionary *newItem = @{
        ETExpenseItemAmountInCentsKey: amountInCents,
        ETExpenseItemExpenseTitleKey: title,
        ETExpenseItemDateOfPurchaseKey: [NSNumber numberWithDouble:[datePurchased timeIntervalSince1970]],
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

- (void)deleteExpenseItem:(ETExpenseItem *)expenseItem completionHandler:(void (^)(NSError * _Nullable))onCompletion {
    
    NSDictionary *data = @{
        ETExpenseItemIdentifierKey: expenseItem.identifier
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
