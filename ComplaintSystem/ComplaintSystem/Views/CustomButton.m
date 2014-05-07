//
//  CustomButton.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-12.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.selected) {
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColor(c, CGColorGetComponents(COLORRGB(0x1db6e2).CGColor));
        
        CGContextMoveToPoint(c, 0, CGRectGetMaxY(rect)-10);
        
        CGContextSetLineWidth(c, 10);
        
        CGContextAddLineToPoint(c, CGRectGetWidth(rect), 0);
        
        CGContextSetFillColor(c, CGColorGetComponents(COLORRGB(0x1db6e2).CGColor));
    }
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
