//
//  ETAppError.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/15/21.
//

#import "ETAppError.h"

NSErrorDomain const ETAppErrorDomain = @"ski.maliszew.Expense-Tracker";

@implementation ETAppError
+ (ETAppError *)appErrorWithErrorCode:(ETAppErrorCode)code {
    NSDictionary<NSErrorUserInfoKey,id> *userInfo;
    switch (code) {
        case ETGenericErrorCode:
            userInfo = @{ NSLocalizedDescriptionKey: @"An error has occurred" };
            break;
        case ETDataConversionFailureErrorCode:
            userInfo = @{NSLocalizedDescriptionKey: @"Unable to convert data successfully" };
            break;
    }
    return [[ETAppError alloc] initWithDomain:ETAppErrorDomain code:code userInfo:userInfo];
}

+ (ETAppError *)appErrorWithErrorMessage:(NSString *)message {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: message };
    return [[ETAppError alloc] initWithDomain:ETAppErrorDomain code:ETGenericErrorCode userInfo:userInfo];
}
@end
