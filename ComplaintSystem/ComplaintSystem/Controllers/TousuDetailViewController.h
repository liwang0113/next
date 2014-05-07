//
//  TousuDetailViewController.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-3.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "BaseViewController.h"
@class TousuEntity;
@interface TousuDetailViewController : BaseViewController
{
    UIView *_showView;
    UIImageView *_showImageView;
    NSMutableArray  *_photoView;
}
@property (nonatomic, strong) TousuEntity *tousu;
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *tousurenText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *timeText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIView *toolBar;


@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end