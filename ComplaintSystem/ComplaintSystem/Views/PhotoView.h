//
//  PhotoView.h
//  XiangYangWuXian
//
//  Created by Cocoa on 14-3-6.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TousuEntity.h"
@protocol PhotoViewDelegate <NSObject>
@optional
-(void)PhotoViewDidClose:(id)sender;
-(void)PhotoViewDidClickedMap:(id)sender;
- (void)PhotoViewDidClickedPhotoWithUserInfo:(id)userinfo;
@end

@interface PhotoView : UIView
{
    @private
    UIButton *_photoView;
}

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, strong) NSURL *videoPath;
@property (nonatomic, strong) FujianEntity *fujian;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image address:(NSString *)address;

- (UIImage *)getImage;

@property (nonatomic, assign) id<PhotoViewDelegate> delegate;



@end
