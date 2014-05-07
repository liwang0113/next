//
//  OpinionViewController.m
//  HEJNews
//
//  Created by yu Andy on 13-12-16.
//  Copyright (c) 2013年 LongYu coltd By Robin. All rights reserved.
//

#import "OpinionViewController.h"
#import <SKPSMTPMessage.h>
#import "UIScrollView+UITouchEvent.h"

@interface OpinionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,SKPSMTPMessageDelegate>
{
    @public
    UITextView  *_contentText;
    UITextField *_emailText;
}
@end

@implementation OpinionViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = COLOR(247., 247., 247.);
    CGRect rect = self.view.frame;
    rect.origin.x = 10;
    rect.size.width = SCREEN_WIDTH-10*2;
    _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.dataSource = self;
    _table.backgroundColor = self.view.backgroundColor;
    _table.backgroundView = nil;
    [self.view addSubview:_table];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";

    UIBarButtonItem *leftButtonItem = [self createImageNavItem2:@"fanhui" andHighlighted:@"fanhuichange" target:self action:@selector(leftBarButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightButtonItem = [self createNavItem:@"发送" target:self action:@selector(rightBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

- (void)leftBarButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 180;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = STRINGFMT(@"cell%d_%d",indexPath.section,indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section==0) {
            self->_contentText = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 300-10*2, 180)];
            self->_contentText.textColor = [UIColor grayColor];
            self->_contentText.delegate = self;
            self->_contentText.text = @"我们很期待您的意见哟～亲";
            [cell.contentView addSubview:self->_contentText];
            [self->_contentText becomeFirstResponder];
        }
        else
        {
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.textLabel.text = @"您的邮箱:";
            self->_emailText = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 200, CGRectGetHeight(cell.frame))];
            self->_emailText.textColor = [UIColor blackColor];
            self->_emailText.delegate = self;
            self->_emailText.placeholder = @"选填，以使我们给您回复";
            self->_emailText.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:self->_emailText];
        }
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    NSString *texts = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (!texts || [texts isEqualToString:@""] || [texts isEqualToString:@"我们很期待您的意见哟～亲"]) {
        [self setRightButtonEnable:NO];
    }
    else
    {
        [self setRightButtonEnable:YES];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"我们很期待您的意见哟～亲"]) {
        [self resetTextViewWithText:textView andIsEnpty:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!textView.text || [textView.text isEqualToString:@""])
    {
        [self resetTextViewWithText:textView andIsEnpty:NO];
    }
}

- (void)resetTextViewWithText:(UITextView *)textView andIsEnpty:(BOOL)isEnpty
{
    if (isEnpty) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
        [self setRightButtonEnable:NO];
        return;
    }
    
    textView.textColor = [UIColor grayColor];
    textView.text = @"我们很期待您的意见哟～亲";
    [self setRightButtonEnable:NO];
}

- (void)rightBarButtonClicked:(id)sender
{
    [_contentText resignFirstResponder];
    [_emailText resignFirstResponder];
    [self sendMail:nil];
}

- (void)sendEMail
{
    [self showMHUD:@"发送中..."];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SKPSMTPMessage *msg = [[SKPSMTPMessage alloc] init];
    msg.delegate = self;
    
    msg.fromEmail = @"qq465428581@163.com";
    msg.toEmail = @"164716961@qq.com";
    msg.bccEmail = [defaults objectForKey:@"bccEmail"];
    msg.relayHost = @"smtp.qq.com";
    
    msg.login = @"qq465428581@163.com";
    msg.pass = @"910731";
    
    msg.wantsSecure = YES;
    
    msg.subject = @"移动取证IPhone App意见反馈";
    
    NSString *body = STRINGFMT(@"%@             用户邮箱:%@",self->_contentText.text,self->_emailText.text);
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,body,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    msg.parts = [NSArray arrayWithObjects:plainPart, nil];
    [msg send];
}


- (IBAction)sendMail:(id)sender
{
    [self showMHUD:@"发送中..."];
    SKPSMTPMessage *test_smtp_message = [[SKPSMTPMessage alloc] init];
    test_smtp_message.fromEmail = @"qq465428581@163.com";
    test_smtp_message.toEmail = @"kinsec_fujian@163.com";
    test_smtp_message.relayHost = @"smtp.163.com";
    test_smtp_message.requiresAuth = YES;
    test_smtp_message.login = @"qq465428581@163.com";
    test_smtp_message.pass = @"910731";
    test_smtp_message.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    test_smtp_message.subject = @"移动取证IPhone客户端意见反馈";
    test_smtp_message.delegate = self;
    
    NSMutableArray *parts_to_send = [NSMutableArray array];

    
    NSString *body = STRINGFMT(@"%@             用户邮箱:%@",self->_contentText.text,self->_emailText.text);
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,body,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    
    [parts_to_send addObject:plainPart];
    
    test_smtp_message.parts = parts_to_send;
    
    [test_smtp_message send];
}


#pragma mark --
#pragma MFMailComposeViewController Delegate
-(void)messageSent:(SKPSMTPMessage *)message
{
    [self hideMHUD];
    ALERT_MSG(@"发送成功");
    [self resetTextViewWithText:self->_contentText andIsEnpty:YES];
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    [self hideMHUD];
    ALERT_MSG(@"发送失败");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_contentText resignFirstResponder];
    [_emailText resignFirstResponder];
}

@end
