//
//  HistoryViewController.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-31.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : BaseViewController
{
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray2;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

- (IBAction)button1Clicked:(id)sender;
- (IBAction)button2Clicked:(id)sender;
@end
