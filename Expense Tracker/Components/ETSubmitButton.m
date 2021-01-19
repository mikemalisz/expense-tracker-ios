//
//  ETSubmitButton.m
//  Expense Tracker
//
//  Created by Mike Maliszewski on 1/18/21.
//

#import "ETSubmitButton.h"

@implementation ETSubmitButton

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (void)configureButton {
    [self setBackgroundColor:self.tintColor];
    [self.layer setCornerRadius:15];
    [self.titleLabel setTextColor:UIColor.whiteColor];
}

@end
