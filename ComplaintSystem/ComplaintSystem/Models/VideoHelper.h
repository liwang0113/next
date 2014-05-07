//
//  VideoHelper.h
//  ComplaintSystem
//
//  Created by Cocoa on 14-5-4.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoHelper : NSObject
+ (NSString *) getFileSize:(NSString *)path;
+ (CGFloat) getVideoLength:(NSURL *)URL;

//获取视屏第一帧图片
+ (UIImage*) getVideoPreViewImageWithPath:(NSURL *)videoPath;

//保存视屏
+ (NSString *)saveVideoWithURL:(NSURL *)videoURL;

@end
