//
//  UITableViewCell+cellIdentifier.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/13/21.
//

#import "UITableViewCell+cellIdentifier.h"

@implementation UITableViewCell (cellIdentifier)
+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}
@end
