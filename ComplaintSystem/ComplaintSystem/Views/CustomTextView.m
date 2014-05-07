//
//  CustomTextView.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-12.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.borderColor = COLORRGB(0xd2d2d2).CGColor;
    self.layer.borderWidth = 1;
}
@end
