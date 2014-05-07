//
//  HistoryViewController.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-3-31.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "HistoryViewController.h"
#import "MyImage.h"
#import "TousuDetailViewController.h"
#import "LHWBase64.h"
#import "RequestCache.h"
#import <CoreLocation/CoreLocation.h>
#import "TousuEntity.h"

@interface Mycell : UITableViewCell
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIImageView *titleView;
@property (nonatomic,strong) UILabel *titlesLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,assign) int isSubmit;
@end

@implementation Mycell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44/2-20/2, 20, 20)];
        [self.contentView addSubview:self.titleView];
        
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 44)];
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.textColor = [UIColor blackColor];
        self.numLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:self.numLabel];
        
        self.titlesLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 + 5, 0, 100, 44)];
        self.titlesLabel.backgroundColor = [UIColor clearColor];
        self.titlesLabel.textColor = [UIColor blackColor];
        self.titlesLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:self.titlesLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 44)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:self.timeLabel];
        
    }
    
    return self;
}


- (void)setIsSubmit:(int)isSubmit
{
    if (isSubmit==1) {
        self.titleView.image = IMG(@"yes_bg");
    }
    else
    {
        self.titleView.image = IMG(@"no_bg");
    }
}
@end

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    RequestCache *_db;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史记录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    _db = [RequestCache db];
    
    self.button1.adjustsImageWhenHighlighted = NO;
    self.button2.adjustsImageWhenHighlighted = NO;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView) {
        
        LHWBACK(^{
            NSArray *array = [_db getList];
            _dataArray = [array copy];
            LHWMAIN(^{
            [self.tableView reloadData];
            });
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    Mycell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( ! cell ) {
        cell = [[Mycell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.numLabel.text = STRINGFMT(@"%d",indexPath.row);
    
    TousuEntity *tousu = _dataArray[indexPath.row];
    
    cell.titlesLabel.text = string(tousu.title);
    cell.timeLabel.text = string(tousu.time);
    cell.isSubmit = tousu.isSubmit;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TousuDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TousuDetailViewController"];
    vc.tousu = _dataArray[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1Clicked:(id)sender
{
    _button1.selected = YES;
    _button2.selected = NO;
    [self.tableView reloadData];
    
}
- (IBAction)button2Clicked:(id)sender
{
    _button1.selected = NO;
    _button2.selected = YES;
    [self.tableView reloadData];
}

@end
