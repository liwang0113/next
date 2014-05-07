//
//  SettingViewController.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-31.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@interface SettingViewController : BaseTableViewController
{
@private
    UISwitch    *_pushSwitch;
    NSMutableArray  *_imageArray;
    NSMutableArray  *_titleArray;
}
@end
