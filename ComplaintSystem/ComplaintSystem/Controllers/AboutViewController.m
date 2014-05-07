//
//  AboutViewController.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-13.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:SCREEN];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:SCREEN];
    im.image = IMG(@"about2");
    [self.view addSubview:im];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于";
    UIBarButtonItem *leftButtonItem = [self createImageNavItem2:@"fanhui" andHighlighted:@"fanhuichange" target:self action:@selector(leftBarButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftBarButtonClicked:(id)sender
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
