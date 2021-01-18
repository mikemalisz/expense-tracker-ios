//
//  ETServerCompletionHandler.h
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/17/21.
//

#import <Foundation/Foundation.h>

typedef void (^ServerCompletionHandler)(NSDictionary * _Nullable data, NSError * _Nullable error);
