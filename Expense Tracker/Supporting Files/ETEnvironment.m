//
//  ETEnvironment.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/21/21.
//

#import "ETEnvironment.h"

@implementation ETEnvironment
+ (NSString *)appMode {
    return [NSBundle.mainBundle.infoDictionary objectForKey:@"APP_MODE"];
}

+ (NSString *)serverURL {
    return [NSBundle.mainBundle.infoDictionary objectForKey:@"SERVER_URL"];
}

@end
