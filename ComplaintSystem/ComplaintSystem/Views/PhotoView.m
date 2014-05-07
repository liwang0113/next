//
//  PhotoView.m
//  XiangYangWuXian
//
//  Created by Cocoa on 14-3-6.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import "PhotoView.h"


@implementation PhotoView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image address:(NSString *)address
{
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 320, 50)];
    if (self) {
        
        self.backgroundColor = COLORRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
        
        _photoView = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoView.frame = CGRectMake(10, 10, 30, 30);
        [_photoView setImage:image forState:UIControlStateNormal];
        [_photoView addTarget:self action:@selector(photoTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoView];
        
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 20)];
        timeL.backgroundColor = [UIColor clearColor];
        timeL.text = [self getTime];
        timeL.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:timeL];
        
        UILabel *addL = [[UILabel alloc] initWithFrame:CGRectMake(50, 5 + 20, SCREEN_WIDTH-50-50, 20)];
        addL.backgroundColor = [UIColor clearColor];
        addL.text = STRINGFMT(@"拍摄地点：%@",address);
        addL.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:addL];
        
        UIButton *showMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [showMapButton setTitle:@"查看地图" forState:UIControlStateNormal];
        [showMapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        showMapButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        showMapButton.frame = CGRectMake(CGRectGetMaxX(addL.frame), 5 + 20 - 10, 50, 40);
        [showMapButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showMapButton];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.frame = CGRectMake(0, 0, 20, 20);
        [_closeButton setImage:IMG(@"baoliao_del") forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        
    }
    return self;
}

- (void)setIsVideo:(BOOL)isVideo
{
    _isVideo = isVideo;
    if (isVideo) {
        
    }
}

- (void)photoTouch:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotoViewDidClickedPhotoWithUserInfo:)]) {
        if (self.isVideo) {
            [self.delegate PhotoViewDidClickedPhotoWithUserInfo:[self videoPath]];
        }else
        {
            [self.delegate PhotoViewDidClickedPhotoWithUserInfo:[self getImage]];
        }
    }
}

- (void)showMap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotoViewDidClickedMap:)]) {
        [self.delegate PhotoViewDidClickedMap:self];
    }
}

- (NSString *)getTime
{
    NSString *d = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年M月d日"];
    
    NSString *s = [df stringFromDate:date];
    
    d = STRINGFMT(@"拍摄时间：%@",s);
    
    return d;
}

- (UIImage *)getImage
{
    return [_photoView imageForState:UIControlStateNormal];
}

- (void)closeButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotoViewDidClose:)]) {
        [self.delegate PhotoViewDidClose:self];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
