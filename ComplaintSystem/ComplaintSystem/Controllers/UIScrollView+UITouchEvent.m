//
//  UIScrollView+UITouchEvent.m
//  XiangYangWuXian
//
//  Created by yu Andy on 14-2-25.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end
