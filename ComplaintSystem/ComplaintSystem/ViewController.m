//
//  ViewController.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-30.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "ViewController.h"
#import "MyImage.h"
#import "PhotoView.h"
#import "LHWBase64.h"
#import "RequestCache.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIScrollView+UITouchEvent.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MapViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoHelper.h"
#import "TousuEntity.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DataUpdateHelp.h"

@interface ViewController ()
<
    UITextFieldDelegate,
    UITextViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    PhotoViewDelegate,
    UIActionSheetDelegate,
    CLLocationManagerDelegate,
    UIAlertViewDelegate,
    DataUpdateHelpDelgate
>
{
    RequestCache            * _db;
    NSString                *_address;
    CLLocationCoordinate2D  _location;
    CLLocationManager       *_locationManager;
    UIView                  *_firstView;
    UIImageView             *_welcomeView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我要取证";
    //设置委托
    [self.titleText setDelegate:self];
    [self.phoneText setDelegate:self];
    [self.contentText setDelegate:self];
    [self.tousurenText setDelegate:self];
    
    CGRect rect = self.scroll.frame;
    rect.size.height = isiPhone5 ? 442 : 442-(548-460);
    self.scroll.frame = rect;
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 443);
    
    rect = self.toolBar.frame;
    rect.origin.y = SCREEN_HEIGHT - rect.size.height;
    self.toolBar.frame = rect;
    
    //初始化模型
    [self initializeModel];
    
    //是否是第一次启动 条款声明
    NSString *isF = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"];
    if (isF && ![Common isBlankString:isF] && [isF isEqualToString:@"1"]) {
    }
    else
    {
        _firstView = [[UIView alloc] initWithFrame:SCREEN];
        _firstView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_firstView];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:SCREEN];
        imageV.image = isiPhone5?IMG(@"first"):IMG(@"first960");
        imageV.userInteractionEnabled = YES;
        [_firstView addSubview:imageV];
        
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        okButton.frame = CGRectMake(50, SCREEN_HEIGHT - 30 - 10, 100, 30);
        okButton.layer.cornerRadius = 6;
        okButton.layer.masksToBounds = YES;
        okButton.layer.borderColor = COLORRGB(0x04b5e1).CGColor;
        okButton.layer.borderWidth = 1;
        [okButton setTitle:@"我接受" forState:UIControlStateNormal];
        okButton.tag = 110;
        [okButton addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [imageV addSubview:okButton];
        
        UIButton *cancelBuootn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBuootn.frame = CGRectMake(SCREEN_WIDTH-50-100, SCREEN_HEIGHT - 30 - 10, 100, 30);
        cancelBuootn.layer.cornerRadius = 6;
        [cancelBuootn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        cancelBuootn.layer.masksToBounds = YES;
        cancelBuootn.layer.borderWidth = 1;
        cancelBuootn.tag = 111;
        cancelBuootn.layer.borderColor = COLORRGB(0x04b5e1).CGColor;
        [cancelBuootn setTitle:@"我不接受" forState:UIControlStateNormal];
        [cancelBuootn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBuootn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [imageV addSubview:cancelBuootn];
    }
    
    
    //GPS是否开启
    [self getGpsOpen];
    
    //初始化图片查看View
    [self init__showView];
}

- (void)getGpsOpen
{
    _welcomeView = [[UIImageView alloc] initWithFrame:SCREEN];
    _welcomeView.image = isiPhone5?IMG(@"Default-568h@2x"):IMG(@"Default640_960");
    [self.view addSubview:_welcomeView];
}

- (void)removeWelcomeView
{
    if (!_welcomeView) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _welcomeView.alpha = 0.2;
    } completion:^(BOOL is){
        [_welcomeView removeFromSuperview];
    }];
}

- (void)ok:(UIButton *)sender
{
    if (sender.tag==110) {
        [UIView animateWithDuration:0.3 animations:^{
            _firstView.alpha = 0.2;
        } completion:^(BOOL is){
            [_firstView removeFromSuperview];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isfirst"];
    }
    else
    {
        [self exitApplication];
    }
}

- (void)initializeModel
{
    //开始定位
    [self startLocation];
    
    _imageArray = [NSMutableArray new];
    _videoArray = [NSMutableArray new];
    _fujianArray = [NSMutableArray new];
    _db = [RequestCache db];
    if (!self.hVC) {
        self.hVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
        [self addChildViewController:self.hVC];
        CGRect r = self.hVC.view.frame;
        r.origin.y = 76;
        self.hVC.view.frame = r;
        [self.view addSubview:self.hVC.view];
        self.hVC.view.hidden = YES;
    }
    
    if (!self.sVC) {
        self.sVC = [SettingViewController new];
        [self addChildViewController:self.sVC];
        CGRect r = self.sVC.view.frame;
        r.origin.y = 76;
        self.sVC.view.frame = r;
        [self.view addSubview:self.sVC.view];
        self.sVC.view.hidden = YES;
    }
}

//开始定位
- (void)startLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}
//获取定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self alertMHUD:@"GPS已开启"];
    
    [self removeWelcomeView];
    
    if (SAFE_ARRAY(locations)) {
        _location = [(CLLocation *)locations[0] coordinate];
        [self startedReverseGeoderWithLatitude:locations[0]];
        //停止定位
        [manager stopUpdatingLocation];
    }
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"GPS未打开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    [alert show];
    
    [self performSelector:@selector(removeAL:) withObject:alert afterDelay:5];
}
//移除申明
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self removeWelcomeView];
}
//自动移除申明
- (void)removeAL:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self removeWelcomeView];
    }
}
//投诉
- (void)tousu
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
                              location:_location
                               address:self.addressText.text
                               fujians:_fujianArray
                              delegate:self];
}

- (void)DataUpdateHelp:(id)_self didFinishWithUserInfo:(id)userinfo
{
    [self dbSave:1 withFujianArray:_fujianArray];
}

//保存到数据库
- (void)dbSave:(int)type withFujianArray:(NSArray *)fujians
{
    //添加到数据库
    [_db addTousuWithTitle:string(self.titleText.text)
                  tousuren:string(self.tousurenText.text)
                     phone:string(self.phoneText.text)
                      time:string([Common getDateString])
                   address:string(self.addressText.text)
                  location:_location
                   content:string(self.contentText.text)
                   fujians:fujians
                  issubmit:type];
}

//图片转换base64字符串
- (NSString *)getBase64StringWithImage:(UIImage *)image
{
    NSData *data  = UIImageJPEGRepresentation(image, 0.4);
    if (!data) {
        data = UIImagePNGRepresentation(image);
    }
    NSString *base_string = [LHWBase64 stringByEncodingData:data];
    return base_string;
}

//清空表单 和 页面
- (void)clean
{
    self.titleText.text = @"";
    self.phoneText.text = @"";
    self.tousurenText.text = @"";
    self.contentText.text = @"";
    self.addressText.text = @"";
    [self update];
    [_fujianArray removeAllObjects];
    [_imageArray makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_imageArray removeAllObjects];
    [self resetPhotoViews];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.phoneText) {
        [UIView animateWithDuration:0.15 animations:^{
            self.scroll.scrollIndicatorInsets = UIEdgeInsetsMake(-100, 0, 0, 0);
            self.scroll.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.phoneText) {
        [UIView animateWithDuration:0.15 animations:^{
            self.scroll.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            self.scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.scroll.scrollIndicatorInsets = UIEdgeInsetsMake(-100, 0, 0, 0);
        self.scroll.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.scroll.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)PhotoViewDidClickedMap:(PhotoView *)sender
{
    MapViewController *mapVC = [MapViewController new];
    mapVC.lo = _location;
    mapVC.address = string(_address);
    [self presentViewController:mapVC animated:YES completion:nil];
    
}

- (IBAction)picAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"拍摄视频", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self selectPicWithCarma];
    }
    else if (buttonIndex==1)
    {
        [self  takeVideo];
    }
}


- (void)takeVideo
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备不支持录制视频");
        return;
    }
    UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
    pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    pickerView.videoMaximumDuration = 300.0f;//设置最长录制5分钟;
    pickerView.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量设置
    pickerView.delegate = self;
    pickerView.allowsEditing = YES;
    [self presentViewController:pickerView animated:YES completion:nil];
}

- (void)selectPicWithAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing=NO;
    picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)selectPicWithCarma
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        ALERT_MSG(@"摄像头不可用");
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing=NO;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeVideo] || [type isEqualToString:(NSString *)kUTTypeMovie]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        NSURL* videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video");
        // 重命名然后保存至本地沙箱目录
        NSData* videoData = [NSData dataWithContentsOfURL:videoURL];//1651392
        
        NSString *newVideoString = [VideoHelper saveVideoWithURL:info[UIImagePickerControllerMediaURL]];
        NSURL *url = [NSURL fileURLWithPath:newVideoString];
        videoData = [NSData dataWithContentsOfURL:url];
        
        if (videoData) {
            [self selectVideo:url fill:newVideoString videoData:videoData];
        }
        
        return;
    }
    
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [Common scaleAndRotateImage:image];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectVideo:(NSURL *)vpath fill:(NSString *)file videoData:(NSData *)data
{
    FujianEntity *Fe = [FujianEntity new];
    Fe.type = kVideo;
    Fe.fujianData = file;
    Fe.data = data;
    Fe.size = [VideoHelper getFileSize:file];
    [_fujianArray addObject:Fe];
    
    PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 317, 0, 0) andImage:[VideoHelper getVideoPreViewImageWithPath:vpath] address:_address];
    photoView.isVideo = YES;
    photoView.fujian = Fe;
    photoView.videoPath = vpath;
    photoView.delegate = self;
    
    [self.scroll addSubview:photoView];
    
    [_imageArray addObject:photoView];
    
    [self resetPhotoViews];
}

- (void)selectPic:(UIImage *)image
{
    FujianEntity *Fe = [FujianEntity new];
    Fe.type = kImage;
    Fe.fujianData = [self getBase64StringWithImage:image];
    //    Fe.size = [VideoHelper getFileSize:<#(NSString *)#>]
    [_fujianArray addObject:Fe];
    
    PhotoView *photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 317, 0, 0) andImage:image address:_address];
    photoView.delegate = self;
    photoView.isVideo = NO;
    photoView.fujian = Fe;
    [self.scroll addSubview:photoView];
    
    [_imageArray addObject:photoView];

    [self resetPhotoViews];
}

- (NSArray *)getVideoFujians
{
    NSMutableArray *temArray = [NSMutableArray new];
    for (FujianEntity *f in _fujianArray) {
        if (f.type==kVideo) {
            [temArray addObject:f];
        }
    }
    return temArray;
}

- (NSArray *)getImageFujians
{
    NSMutableArray *temArray = [NSMutableArray new];
    for (FujianEntity *f in _fujianArray) {
        if (f.type==kImage) {
            [temArray addObject:f];
        }
    }
    return temArray;
}

- (BOOL)ishasVideo
{
    BOOL ret = NO;
    do {
        for (FujianEntity *f in _fujianArray) {
            if (f.type==kVideo) {
                ret = YES;
                break;
            }
        }
    } while (0);
    return ret;
}

-(void)resetPhotoViews
{
    self.scroll.contentSize = CGSizeMake(320, 443+_imageArray.count*60);
    
    int h = 317+50+40;
    for (int i=0; i<_imageArray.count; i++) {
        PhotoView *ph = [_imageArray objectAtIndex:i];
        CGRect rect = ph.frame;
        ph.tag = i;
        rect.origin.y = h;
        ph.frame = rect;
        h+=60;
    }
    self.scroll.contentOffset = CGPointMake(0, self.scroll.contentSize.height-CGRectGetHeight(self.scroll.frame));
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)PhotoViewDidClose:(id)photoView
{
    [_fujianArray removeObject:[(PhotoView *)photoView fujian]];
    
    [photoView removeFromSuperview];
    [_imageArray removeObject:photoView];
    
    [self resetPhotoViews];
}

- (IBAction)sijiao:(id)sender
{
    [self tousu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)redo:(id)sender
{
    [self clean];
}

#pragma mark - 保存到数据库
- (IBAction)save:(id)sender
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
    
    //取消键盘
    [self touchesBegan:nil withEvent:nil];

    //添加到数据库
    [_db addTousuWithTitle:string(self.titleText.text)
                  tousuren:string(self.tousurenText.text)
                     phone:string(self.phoneText.text)
                      time:string([Common getDateString])
                   address:string(self.addressText.text)
                  location:_location
                   content:string(self.contentText.text)
                   fujians:_fujianArray
                  issubmit:0];
    
    //清空本页内容
    [self clean];
    
    ALERT_MSG(@"保存成功");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.contentText resignFirstResponder];
    [self.tousurenText resignFirstResponder];
    [self.addressText resignFirstResponder];
}

- (void)startedReverseGeoderWithLatitude:(CLLocation *)lo
{
    CLGeocoder *geoCode = [[CLGeocoder alloc] init];
    [geoCode reverseGeocodeLocation:lo completionHandler:^(NSArray *arr, NSError *error){
        
        if (SAFE_ARRAY(arr)) {
            CLPlacemark *placemark = arr[0];
            id thing = placemark.addressDictionary[@"FormattedAddressLines"];
            if ([thing isKindOfClass:[NSArray class]]) {
                NSString  *a = thing[0];
                _address = string(a);
            }
            else if ([thing isKindOfClass:[NSString class]])
            {
                _address = [thing copy];
            }
            
            NSLog(@"经纬度所对应的详细地址:%@",_address);
        }
    }];
}


- (IBAction)menuAction:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.button3.selected = NO;
    
    if (sender==self.button1) {
        self.hVC.view.hidden = YES;
        self.sVC.view.hidden = YES;
    }
    else if (sender==self.button2)
    {
        self.hVC.view.hidden = NO;
        self.sVC.view.hidden = YES;
    }
    else
    {
        self.hVC.view.hidden = YES;
        self.sVC.view.hidden = NO;
        
    }
    
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect r = self.menuBgImageView.frame;
        r.origin.x = CGRectGetMinX(sender.frame);
        self.menuBgImageView.frame = r;
    }];
    
}

- (void)update
{
    if (self.hVC) {
        [self.hVC viewWillAppear:YES];
    }
}

- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    UIWindow *window =  [[[UIApplication sharedApplication] delegate] window];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
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

- (IBAction)getAddress:(id)sender
{
    self.addressText.text = _address;
}
@end
