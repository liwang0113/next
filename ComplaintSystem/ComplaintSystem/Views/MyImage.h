//
//  MyImage.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-31.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (UIImageExt)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

