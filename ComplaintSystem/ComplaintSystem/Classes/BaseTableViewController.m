//
//  BaseTableViewController.m
//  XiangYangWuXian
//
//  Created by yu Andy on 14-3-11.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//


#import "BaseTableViewController.h"
#import "MBProgressHUD.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
}

- (void)showNavigationBar
{
    [self.navigationController.navigationBar setBackgroundColor:COLOR(69., 81., 142.)];
    self.navigationController.navigationBar.tintColor = COLOR(69., 81., 142.);
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        [self.navigationController.navigationBar setBarTintColor:COLOR(69., 81., 142.)];
    }
#endif
    
    [self.navigationController.navigationBar setBackgroundImage:IMG(@"na_bg") forBarMetrics:UIBarMetricsDefault];
}

-(UIButton *)createNavButton:(NSString *)title target:(id)__sender action:(SEL)action
{
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(0, 0, 50, 40);
    
    [cityButton setTitle:title forState:UIControlStateNormal];
    cityButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [cityButton setTitle:@"确定" forState:UIControlStateSelected];
    [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityButton addTarget:__sender action:action forControlEvents:UIControlEventTouchUpInside];
    cityButton.showsTouchWhenHighlighted = YES;
    return cityButton;
}

-(UIButton *)createNavigationImgButton:(NSString *)img action:(SEL)action
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:img];
    backBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return backBtn;
}

-(UIBarButtonItem*)createImageNavItem:(NSString *)img andHighlighted:(NSString *)img2 target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    
    if (ISIOS7) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 17);
    }
    else
    {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    }
    
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img2] forState:UIControlStateHighlighted];
    button.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

-(UIBarButtonItem*)createImageNavItem2:(NSString *)img andHighlighted:(NSString *)img2 target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    if (ISIOS7) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, -12);
    }
    else
    {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    }
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img2] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

-(UIBarButtonItem*)createNavItem:(NSString *)title target:(id)sender__ action:(SEL)action
{
    _rightButton = [self createNavButton:title target:sender__ action:action];
    [_rightButton setTitleColor:COLOR(84., 175., 190.) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    return item;
}

- (UIBarButtonItem *)createBarItemWith:(NSString *)image target:(id)target action:(SEL)action isLeft:(BOOL)isLeft
{
    if (isLeft) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 44, 44);
        [_leftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [_leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
        return item;
    }
    else
    {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 44, 44);
        [_rightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [_rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        return item;
    }
}


-(void)showMHUD:(NSString *)msg
{
    if (_HUD) {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD setLabelFont:[UIFont systemFontOfSize:12]];
	[_HUD setLabelText:msg];
	[_HUD show:YES];
}

-(void)hideMHUD
{
    if (_HUD) {
        [_HUD hide:YES];
        _HUD=nil;
    }
}

-(void)hideMHUD:(NSString *)msg success:(BOOL)success
{
    if (success) {
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }else{
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-warning.png"]];
    }
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = msg;
    [_HUD hide:YES afterDelay:1];
}

-(void)alertMHUD:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-warning.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    [_HUD setLabelFont:[UIFont systemFontOfSize:12]];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)alertMHUDOK:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    [_HUD setLabelFont:[UIFont systemFontOfSize:12]];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

