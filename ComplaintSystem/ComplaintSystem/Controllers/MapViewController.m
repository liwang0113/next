//
//  MapViewController.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-12.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "MapViewController.h"
#import "BMapKit.h"
#import "LHWBase64.h"
@interface MapViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    UIButton *_mapCloseButton;
    
}
@end

@implementation MapViewController


- (void)loadView
{
    [super loadView];
    UIView *view = [[UIView alloc] initWithFrame:SCREEN];
    self.view = view;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mapView = [[BMKMapView alloc] initWithFrame:SCREEN];
    _mapView.zoomLevel = 15;
    _mapView.delegate = self;

    _mapView.centerCoordinate = [self getL];
    [self.view addSubview:_mapView];
}

- (CLLocationCoordinate2D)getL
{
    NSDictionary *d = BMKBaiduCoorForWgs84(self.lo);
    double x = [[[NSString alloc] initWithData:[LHWBase64 decodeString:string(d[@"x"])] encoding:NSUTF8StringEncoding] doubleValue];
    double y = [[[NSString alloc] initWithData:[LHWBase64 decodeString:string(d[@"y"])] encoding:NSUTF8StringEncoding] doubleValue];
    return CLLocationCoordinate2DMake(y, x);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
    pointAnnotation.coordinate = [self getL];
    pointAnnotation.title = string(self.address);
    [_mapView addAnnotation:pointAnnotation];

    _mapCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mapCloseButton.frame = CGRectMake(0, 10, 44, 44);
    _mapCloseButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_mapCloseButton setImage:IMG(@"app_sc") forState:UIControlStateNormal];
    [self.view addSubview:_mapCloseButton];
    [_mapCloseButton addTarget:self action:@selector(coloseMap:) forControlEvents:UIControlEventTouchUpInside];
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

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}


- (void)coloseMap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
