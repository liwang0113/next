//
//  SettingViewController.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-31.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "SettingViewController.h"
#import "MyImage.h"
#import "OpinionViewController.h"
#import "NSNavigationControler.h"
#import "AboutViewController.h"

@interface myCell : UITableViewCell
@end
@implementation myCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.backgroundView.frame;
    r.size.width = SCREEN_WIDTH-20;
    r.origin.x = 10;
    self.backgroundView.frame = r;
    self.selectedBackgroundView.frame = r;
    self.contentView.frame = r;
}

@end

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SettingViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    i.image = IMG(@"bg");
    
    self.tableView.backgroundView = i;
    
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:
                   @"检查更新",
                   @"意见反馈",
                   @"关于",
                   @"退出程序",nil];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = STRINGFMT(@"cell%d_%d",indexPath.section,indexPath.row);
    
    myCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[myCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"设置";
        CGRect rect = cell.contentView.frame;

        UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:rect];
        UIImageView *bgImageVSelected = [[UIImageView alloc] initWithFrame:rect];
        cell.backgroundView = bgImageV;
        cell.selectedBackgroundView = bgImageVSelected;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.textLabel.text = [_titleArray objectAtIndex:indexPath.section*3+indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
        switch (indexPath.row) {
            case 0:
                bgImageV.image = IMG(@"shang");
                bgImageVSelected.image = IMG(@"shangchange");
                cell.imageView.image = IMG(@"tuijian");
                break;
            case 1:
            case 2:
            {
                bgImageV.image = IMG(@"zhong");
                bgImageVSelected.image = IMG(@"zhongchange");
                cell.imageView.image = IMG(indexPath.row==1?@"yijian":@"guanyu");
                UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
                vie.backgroundColor = COLOR(240., 240., 240.);
                [cell addSubview:vie];
            }
                break;
            case 3:
            {
                bgImageV.image = IMG(@"xia");
                bgImageVSelected.image = IMG(@"xiachange");
                cell.imageView.image = IMG(@"pingfen");
                UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
                vie.backgroundColor = COLOR(240., 240., 240.);
                [cell addSubview:vie];
            }
                break;
            default:
                break;
        }

        
    }
    
    return cell;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 30, 11, 11)];
    imageView.image = IMG(section==0?@"rben":@"ouzhou");
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+18, 24, 100, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = section==0?@"功能设置":@"其他";
    [view addSubview:titleLabel];
    
    return view;
}
 
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                [self getVesionRequest];
            }
                break;
            case 1:
            {
                OpinionViewController *vc = [OpinionViewController new];
                NSNavigationControler *nav = [[NSNavigationControler alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 2:
            {
                AboutViewController *vc = [AboutViewController new];
                NSNavigationControler *nav = [[NSNavigationControler alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 3:
            {
                [self exitApplication];
            }
                break;
            default:
                break;
        }
    }
 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self cleanCache];
    }
}

- (void)cleanCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"CaceResource"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManage removeItemAtPath:documentDirectory error:&error];
    if (error) {
        cout(@"清除失败");
    }
    else
    {
        ALERT_MSG(@"缓存清理完成");
    }
}


- (void)switchChanged:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults]
     setObject:STRINGFMT(@"%d",sender.on) forKey:@"push"];
}

- (BOOL)getPush
{
    BOOL openPush = NO;
    do {
        NSString *push = [[NSUserDefaults standardUserDefaults] objectForKey:@"push"];
        if (!push) {
            break;
        }
        openPush = push.boolValue;
    } while (false);
    return openPush;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    UIWindow *window =  [[[UIApplication sharedApplication] delegate] window];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
}


- (void)getVesionRequest
{
    [self showMHUD:@"正在加载..."];
    NSDictionary *d = @{@"Type":@"iOS"};
    LHWRequest *reques = CREATE_WEB_SER(nil, @"GetLatestVersion", d);
    [reques setSuccess:^(LHWRequest *request, id respond){
        NSLog(@"%@",respond);
        NSString *result = respond[@"result"];
        if (SAFE_STRING(result) && ![result isEqualToString:@""]) {
            float newVesion = [result floatValue];
            float oldVesion = [self getFloatV];
            if (newVesion>oldVesion) {
                [self getURLRequest];
            }
        }
        else
        {
            [self hideMHUD];
            ALERT_MSG(@"你已经是最新版本！");
        }
        
    } failure:^(LHWRequest *request, NSError *error)
     {
         [self hideMHUD];
         ALERT_MSG(@"加载失败，请稍后重试！");
     }];
    [reques startAsynchronous];
}

- (void)getURLRequest
{
    NSDictionary *d = @{@"Type":@"iOS"};
    LHWRequest *reques = CREATE_WEB_SER(nil, @"GetDownloadUrl", d);
    [reques setSuccess:^(LHWRequest *request, id respond){
        NSLog(@"%@",respond);
        NSString *result = respond[@"result"];
        [self hideMHUD];
        if (SAFE_STRING(result) && ![respond isEqualToString:@""]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string(respond)]];
        }
        else
        {
            ALERT_MSG(@"你已经是最新版本！");
        }
        
    } failure:^(LHWRequest *request, NSError *error)
     {
         [self hideMHUD];
         ALERT_MSG(@"加载失败，请稍后重试！");
     }];
    [reques startAsynchronous];
}

- (NSString *)getSysV
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

- (float)getFloatV
{
    NSString *v = [self getSysV];
    return [v floatValue];
}

@end
