//
//  ETAppError.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETAppError.h"

NSErrorDomain const ETAppErrorDomain = @"ski.maliszew.Expense-Tracker";

@implementation ETAppError
+ (ETAppError *)initWithErrorCode:(ETAppErrorCode)code {
    NSDictionary<NSErrorUserInfoKey,id> *userInfo;
    switch (code) {
        case ETDataConversionFailureErrorCode:
            userInfo = @{NSLocalizedDescriptionKey: @"Unable to convert data successfully" };
            break;
    }
    return [[ETAppError alloc] initWithDomain:ETAppErrorDomain code:code userInfo:userInfo];
}
@end
