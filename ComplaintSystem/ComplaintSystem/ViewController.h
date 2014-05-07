//
//  ViewController.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-30.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoView;
#import "HistoryViewController.h"
#import "SettingViewController.h"

@interface ViewController : BaseViewController
{
    NSMutableArray *_imageArray;
    NSMutableArray *_videoArray;
    
    NSMutableArray  *_fujianArray;
    
    UIView      *_showView;
    UIImageView *_showImageView;
}
@property (weak, nonatomic) IBOutlet UIView         *toolBar;
@property (weak, nonatomic) IBOutlet UITextField    *tousurenText;
@property (weak, nonatomic) IBOutlet UITextField    *titleText;
@property (weak, nonatomic) IBOutlet UITextField    *phoneText;
@property (weak, nonatomic) IBOutlet UITextField    *addressText;
@property (weak, nonatomic) IBOutlet UITextView     *contentText;
@property (weak, nonatomic) IBOutlet UIButton       *button1;
@property (weak, nonatomic) IBOutlet UIButton       *button2;
@property (weak, nonatomic) IBOutlet UIButton       *button3;
@property (weak, nonatomic) IBOutlet UIScrollView   *scroll;
@property (weak, nonatomic) IBOutlet UIImageView    *menuBgImageView;


@property (strong, nonatomic) HistoryViewController   *hVC;
@property (strong, nonatomic) SettingViewController   *sVC;
- (IBAction)picAction:(id)sender;

- (IBAction)sijiao:(id)sender;

- (IBAction)getAddress:(id)sender;

- (IBAction)redo:(id)sender;

- (IBAction)save:(id)sender;

- (IBAction)menuAction:(id)sender;

- (void)clean;
@end
