//
//  TousuDetailViewController.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-3.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "TousuDetailViewController.h"
#import "TousuEntity.h"
#import "LHWBase64.h"
#import "BMapKit.h"
#import "PhotoView.h"
#import "UIScrollView+UITouchEvent.h"
#import "MapViewController.h"
#import "RequestCache.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DataUpdateHelp.h"

@interface TousuDetailViewController ()<UITabBarControllerDelegate,BMKMapViewDelegate,PhotoViewDelegate,UIScrollViewDelegate,DataUpdateHelpDelgate>
{
    BMKMapView *_mapView;
    UIButton    *_mapButton;
    UIButton    *_mapCloseButton;
    RequestCache* _db;
}
@end

@implementation TousuDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _db = [RequestCache db];
    _photoView = [NSMutableArray new];
    
    //初始化值
    self.titleText.text = string(self.tousu.title);
    self.phoneText.text = string(self.tousu.phone);
    self.addressText.text = string(self.tousu.address);
    self.timeText.text = string(self.tousu.time);
    self.contentText.text = string(self.tousu.content);
    self.tousurenText.text = string(self.tousu.tousuren);
    
    //返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(320/2- 100/2, CGRectGetHeight(self.toolBar.frame)/2 - 30/2, 100, 30);
    self.backButton.layer.cornerRadius = 5;
    self.backButton.layer.masksToBounds = YES;
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.backButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.layer.borderWidth = 1;
    [self.toolBar addSubview:self.backButton];
    
    //如果是已提交的内容 就不允许再提交
    if (!self.tousu.isSubmit) {
        self.titleText.userInteractionEnabled = YES;
        self.phoneText.userInteractionEnabled = YES;
        self.timeText.userInteractionEnabled = YES;
        self.contentText.userInteractionEnabled = YES;
        self.tousurenText.userInteractionEnabled = YES;
        self.addressText.userInteractionEnabled = YES;
        
        self.backButton.frame = CGRectMake(50, CGRectGetHeight(self.toolBar.frame)/2 - 30/2, 100, 30);
        
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.frame = CGRectMake(320-50-100, CGRectGetHeight(self.toolBar.frame)/2 - 30/2, 100, 30);
        self.submitButton.layer.cornerRadius = 5;
        [self.submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.submitButton.layer.masksToBounds = YES;
        self.submitButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.submitButton.layer.borderWidth = 1;
        [self.submitButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.toolBar addSubview:self.submitButton];
    }
    
    CGRect rect = self.scroll.frame;
    rect.size.height = isiPhone5 ? 441 : 441-(548-460);
    self.scroll.frame = rect;
    
    //下方工具栏
    rect = self.toolBar.frame;
    rect.origin.y = SCREEN_HEIGHT - rect.size.height;
    self.toolBar.frame = rect;
    
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH,  (360 + 60*self.tousu.fujian.count)>self.scroll.frame.size.height?(50 + 40 + 360 + 60*self.tousu.fujian.count):50 + 40 + self.scroll.frame.size.height+5);
    
    //添加附件
    for (int i=0; i<self.tousu.fujian.count; i++) {
        FujianEntity *fujian = self.tousu.fujian[i];
        
        UIImage *image = nil;
        if (fujian.type==kImage) {
            NSData *imageData = [LHWBase64 decodeData:[fujian.fujianData dataUsingEncoding:NSUTF8StringEncoding]];
            image = [UIImage imageWithData:imageData];
        }
        else
        {
            image = [VideoHelper getVideoPreViewImageWithPath:[NSURL fileURLWithPath:string(fujian.fujianData)]];
        }
        
        PhotoView *photoV = [[PhotoView alloc] initWithFrame:CGRectMake(0, 334 + 20 + 60*i + 50 + 40, 0, 0) andImage:image address:self.tousu.address];
        photoV.isVideo = NO;
        if (fujian.type==kVideo) {
            photoV.isVideo = YES;
            photoV.videoPath = [NSURL fileURLWithPath:string(fujian.fujianData)];
        }
        
        photoV.closeButton.hidden = YES;
        photoV.delegate = self;
        
        [_photoView addObject:photoV];
        
        [self.scroll addSubview:photoV];
    }
    
    [self init__showView];
}

- (void)PhotoViewDidClickedMap:(id)sender
{
    MapViewController *map = [MapViewController new];
    map.lo = self.tousu.location;
    map.address = string(self.tousu.address);
    [self presentViewController:map animated:YES completion:nil];
}

- (void)coloseMap:(UIButton *)sender
{
    [self.scroll insertSubview:_mapView belowSubview:_mapButton];
    
    _mapCloseButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _mapView.frame = self.addressText.frame;
    } completion:^(BOOL iscom){
        _mapButton.hidden = NO;
    }];
}

- (void)mapTouch:(id)sender
{
    [self.view addSubview:_mapView];
    _mapView.frame = [self.scroll convertRect:_mapView.frame toView:self.view];
    
    CGRect rect = _mapView.frame;
    rect.size.height = SCREEN_HEIGHT;
    rect.size.width = SCREEN_WIDTH;
    rect.origin.y = 0;
    rect.origin.x = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _mapView.frame = rect;
        
    } completion:^(BOOL iscom){
        _mapCloseButton.hidden = NO;
        [self.view bringSubviewToFront:_mapCloseButton];
        _mapButton.hidden = YES;
    }];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 设置颜色
    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    ((BMKPinAnnotationView*)newAnnotation).animatesDrop = NO;
    // 设置可拖拽
    ((BMKPinAnnotationView*)newAnnotation).draggable = NO;
    return newAnnotation;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.timeText resignFirstResponder];
    [self.contentText resignFirstResponder];
    [self.tousurenText resignFirstResponder];
    [self.addressText resignFirstResponder];
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doTousu
{
    if ([Common isBlankString:self.titleText.text]) {
        ALERT_MSG(@"标题不能为空！");
        return;
    }
    if ([Common isBlankString:self.tousurenText.text]) {
        ALERT_MSG(@"取证人不能为空！");
        return;
    }
    if ([Common isBlankString:self.phoneText.text]) {
        ALERT_MSG(@"联系方式不能为空！");
        return;
    }
    if ([Common isBlankString:self.addressText.text]) {
        ALERT_MSG(@"取证地址不能为空！");
        return;
    }
    if ([Common isBlankString:self.contentText.text]) {
        ALERT_MSG(@"取证内容不能为空！");
        return;
    }
    
    [self touchesBegan:nil withEvent:nil];
    
    [self showMHUD:@"提交中..."];
    
    DataUpdateHelp *dataHelp = [DataUpdateHelp new];
    dataHelp.deleagte = self;
    [dataHelp doUpdateContentWithTitle:self.titleText.text
                              tousuRen:self.tousurenText.text
                                 phone:self.phoneText.text
                               content:self.contentText.text
                              location:self.tousu.location
                               address:self.addressText.text
                               fujians:self.tousu.fujian
                              delegate:self];
    
}

- (void)DataUpdateHelp:(id)_self didFinishWithUserInfo:(id)userinfo
{
    [self doSave];
}

- (void)doSave
{
    [_db deleWithID:self.tousu.ids];
    
    //添加到数据库
    [_db addTousuWithTitle:string(self.titleText.text)
                  tousuren:string(self.tousurenText.text)
                     phone:string(self.phoneText.text)
                      time:string([Common getDateString])
                   address:string(self.addressText.text)
                  location:self.tousu.location
                   content:string(self.contentText.text)
                   fujians:self.tousu.fujian
                  issubmit:1];
}

- (void)submitButtonClicked:(id)sender
{
    [self doTousu];
}

- (void)init__showView
{
    _showView = [UIView new];
    _showView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT);
    _showView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_showView];
    _showView.hidden = YES;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    scroll.delegate = self;
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setShowsVerticalScrollIndicator:NO];
    [scroll setMaximumZoomScale:20.0];
    scroll.backgroundColor = [UIColor clearColor];
    [_showView addSubview:scroll];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveView)];
    tap.numberOfTapsRequired = 1;
    [scroll addGestureRecognizer:tap];
    
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scroll addSubview:_showImageView];
}

- (void)moveView
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration
                     animations:^{
                         _showView.alpha = 0;
                     }
                     completion:^(BOOL iscom){
                         _showView.hidden = YES;
                         _showView.alpha = 1;
                     }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _showImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _showImageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

- (void)showWithImaeg:(UIImage *)im
{
    _showView.hidden = NO;
    _showImageView.image = im;
}

- (void)PhotoViewDidClickedPhotoWithUserInfo:(id)userinfo
{
    if ([userinfo isKindOfClass:[UIImage class]]) {
        [self showWithImaeg:(UIImage *)userinfo];
    }
    else
    {
        [self playMovieAtURL:userinfo];
    }
}

- (void)playMovieAtURL:(NSURL*)theURL
{
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc] initWithContentURL:theURL];

    playerViewController.moviePlayer.scalingMode=MPMovieControlModeDefault;
    [playerViewController.moviePlayer shouldAutoplay];
    [playerViewController.moviePlayer play];
    
    [self presentViewController:playerViewController animated:YES completion:nil];
}

- (void)clean
{
    self.titleText.text = @"";
    self.phoneText.text = @"";
    self.tousurenText.text = @"";
    self.contentText.text = @"";
    self.addressText.text = @"";
    self.timeText.text = @"";
    [_photoView makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
}

@end
