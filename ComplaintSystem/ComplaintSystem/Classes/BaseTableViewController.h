//
//  BaseTableViewController.h
//  XiangYangWuXian
//
//  Created by yu Andy on 14-3-11.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface BaseTableViewController : UITableViewController
{
    @private
    MBProgressHUD *_HUD;
    
    @public
    UIButton    *_rightButton;
    UIButton    *_leftButton;
}

-(void)showMHUD:(NSString *)msg;
-(void)hideMHUD;
-(void)hideMHUD:(NSString *)msg success:(BOOL)success;
-(void)alertMHUD:(NSString *)msg;
-(void)alertMHUDOK:(NSString *)msg;
- (void)showNavigationBar;
-(UIBarButtonItem*)createImageNavItem:(NSString *)img andHighlighted:(NSString *)img2 target:(id)target action:(SEL)action;
-(UIBarButtonItem*)createNavItem:(NSString *)title target:(id)sender__ action:(SEL)action;

-(UIBarButtonItem*)createImageNavItem2:(NSString *)img andHighlighted:(NSString *)img2 target:(id)target action:(SEL)action;



- (UIBarButtonItem *)createBarItemWith:(NSString *)image target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

@end