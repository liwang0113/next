//
//  VideoHelper.m
//  ComplaintSystem
//
//  Created by Cocoa on 14-5-4.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "VideoHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation VideoHelper

//此方法可以获取文件大小，返回的是单位是KB。
+ (NSString *) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    if (filesize>=1024) {
        filesize = 1.0*filesize/1024;
        return [NSString stringWithFormat:@"%fm",filesize];
    }
    
    return [NSString stringWithFormat:@"%fkb",filesize];
}

//此方法可以获取视频文件的时长。
+ (CGFloat) getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}


+ (UIImage*) getVideoPreViewImageWithPath:(NSURL *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return img;
}

+ (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}


- (void)convert:(NSURL *)sourceURL
{
    //转换时文件不能已存在，否则出错
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
    NSLog(@"%@",resultPath);
    
    exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
}

+ (NSString *)saveVideoWithURL:(NSURL *)videoURL
{
    // 重命名然后保存至本地沙箱目录
    NSData *videoData = nil;
    videoData = [NSData dataWithContentsOfURL:videoURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *theDate = nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy||HH:mm:SS"];
    NSDate *now = [[NSDate alloc] init];
    theDate = [dateFormat stringFromDate:now];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *videopath= [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.mov",documentsDirectory,theDate]];
    
    BOOL success = [videoData writeToFile:videopath atomically:NO];
    
//    [self lowQuailtyWithInputURL:videoURL
//                       outputURL:[NSURL fileURLWithPath:videopath]
//                    blockHandler:^(AVAssetExportSession * av)
//    {
//        switch (av.status) {
//            case AVAssetExportSessionStatusUnknown:
//                NSLog(@"AVAssetExportSessionStatusUnknown");
//                break;
//            case AVAssetExportSessionStatusWaiting:
//                NSLog(@"AVAssetExportSessionStatusWaiting");
//                break;
//            case AVAssetExportSessionStatusExporting:
//                NSLog(@"AVAssetExportSessionStatusExporting");
//                break;
//            case AVAssetExportSessionStatusCompleted:
//                NSLog(@"AVAssetExportSessionStatusCompleted");
//                break;
//            case AVAssetExportSessionStatusFailed:
//                NSLog(@"AVAssetExportSessionStatusFailed");
//                break;
//        }
//    }];
    
    return videopath;
}
@end
