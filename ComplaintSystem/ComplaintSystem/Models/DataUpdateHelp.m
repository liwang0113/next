//
//  DataUpdateHelp.m
//  ComplaintSystem
//
//  Created by yu Andy on 14-5-6.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import "DataUpdateHelp.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
@implementation DataUpdateHelp





#pragma mark - 提交到服务器  先提交内容--》提交图片--》提交视屏
- (void)doUpdateContentWithTitle:(NSString *)title
                        tousuRen:(NSString *)tousuRen
                           phone:(NSString *)phone
                         content:(NSString *)content
                        location:(CLLocationCoordinate2D)location
                         address:(NSString *)address
                          fujians:(NSArray *)fujians
                        delegate:(id)delegate
{
    self.delegate = delegate;
    self.fujianArray = [fujians copy];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    SETVALUE(dic, string(title), @"title");
    SETVALUE(dic, string(tousuRen), @"creator");
    SETVALUE(dic, string(phone), @"tel");
    SETVALUE(dic, string(content), @"content");
    SETVALUE(dic, string([self getDateString]), @"createTime");
    SETVALUE(dic, STRINGFMT(@"%f",location.longitude), @"longitude");//经度
    SETVALUE(dic, STRINGFMT(@"%f",location.latitude), @"latitude");//纬度
    SETVALUE(dic, string(address), @"address");
    SETVALUE(dic, @"", @"imageBuffer");//图片信息
    
    //取出附件列表
    __block NSArray *base64Images = [self getImgArr:[self getImageFujiansWithFujians:fujians]];
    
    //提示
    [self Cstate:@"正在提交内容..."];
    
    LHWRequest *reques = CREATE_WEB_SER(nil, @"UploadPhotoEx", dic);
    [reques setSuccess:^(LHWRequest *request, id respond){
        //获取文件名称
        self.fileName = VALUE(respond, @"result");

        [self notDelegate];
        
        [self doImageWithFujians:base64Images];
 
    } failure:^(LHWRequest *request, NSError *error)
     {
         //失败，就直接取消
         [self HidHud];
         ALERT_MSG(@"加载失败，请稍后重试！");
     }];
    [reques startAsynchronous];
}

- (void)doImageWithFujians:(NSArray *)base64Images
{
    //if 有图片 就上传
    if (SAFE_ARRAY(base64Images))
    {
        //提交全部图片
        [self addPhotoWithFileName:self.fileName
                      imagesBase64:base64Images];
    }
    else
    {
        //if 没图片，检查是否有视屏，有，上传视屏
        if (SAFE_ARRAY([self getVideoFujiansWithFujians:self.fujianArray]))
        {
            [self doVideoWithFileName:self.fileName];
        }
        else
        {
            //清楚表单内容
            [self clean];
            
            //隐藏加载提示
            [self HidHud];
            
            ALERT_MSG(@"提交成功");
        }
    }
}

- (void)notDelegate
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(DataUpdateHelp:didFinishWithUserInfo:)]) {
        [self.deleagte DataUpdateHelp:self didFinishWithUserInfo:nil];
    }
}

//上传照片
- (void)addPhotoWithFileName:(NSString *)filename
                imagesBase64:(NSArray *)image
{
    [self Cstate:@"正在提交图片..."];
    
    __block unsigned num = 0;
    
    __block NSArray *temArray = [image copy];
    
    for (int i=0; i<image.count; i++)
    {
        //获取图片
        NSString *base64 = image[i];
        NSDictionary *D = @{@"fileName": string(filename), @"imageBuffer": string(base64)};
        NSLog(@"fileName:%@",filename);
        
        LHWRequest *R = CREATE_WEB_SER(nil, @"AddPhoto", D);
        
        [R setSuccess:^(LHWRequest *request, id respond){
            num++;
            //成功
            if (respond && [string(VALUE(respond, @"result")) isEqualToString:@"true"]) {
                NSLog(@"图片:%d 上传成功",num);
            }
            
            //如果上传完毕
            if (num>=temArray.count) {
                [self doVideoWithFileName:filename];
            }
            
        } failure:^(LHWRequest *request, NSError *error)
         {
             [self HidHud];
             num++;
         }];
        [R startAsynchronous];
    }
}



- (void)doVideoWithFileName:(NSString *)filename
{
    [self Cstate:@"正在提交视频..."];
    
    __block int num = 0;
    
    NSArray *temA = [self getVideoFujiansWithFujians:self.fujianArray];
    
    for (int i=0; i<temA.count; i++) {
        
        __block FujianEntity *fujian = temA[i];
        
        [self uploadVideoWithViedoData:fujian.data
                              fileName:filename
                        andFinishBlock:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            //递增
            num++;
            
            NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"result from webservice:::--> %@", returnString);
            returnString = [returnString stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([returnString isEqualToString:@"true"]) {
                NSLog(@"视频：%@ 上传成功",fujian.fujianData);
            }
            else
            {
                NSLog(@"视频：%@ 上传失败  错误：%@",fujian.fujianData,error.localizedDescription);
            }
            
            if (num>=temA.count) {
                [self clean];
                [self HidHud];
                ALERT_MSG(@"上传成功");
            }
            
        }];
    }
}


- (void)uploadVideoWithViedoData:(NSData *)videoData
                        fileName:(NSString *)fileName
                  andFinishBlock:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))finishb
{
    if (!SAFE_STRING(fileName))
    {
        return;
    }
    NSData *imageData = videoData;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:60];
    [request setURL:[NSURL URLWithString:STRINGFMT(@"http://test.fdserve.com/complaint/VideoHandler.ashx?filename=%@&videotype=mov",fileName)]];
    
    [request setHTTPMethod:@"POST"];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data"];
    [request addValue:@"keep-alive" forHTTPHeaderField: @"connection"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /* 通过post方式上传视频 */
    NSMutableData *body = [NSMutableData data];
    [body appendData:[NSData dataWithData:imageData]];
    
    [request setHTTPBody:body];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//    {
//        NSLog(@"resout %@",response);
//        
//        finishb(response,data,error);
//    }];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"resout %@",data);
    if (data) {
        finishb(nil,data,nil);
    }
}

//获取现在时间
- (NSString *)getDateString
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    return dateString;
}

//改变提示信息
- (void)Cstate:(NSString *)msg
{
    [self.delegate changeText:msg];
}

- (NSArray *)getImgArr:(NSArray *)tA
{
    NSMutableArray *A = [NSMutableArray new];
    for (int i=0; i<tA.count; i++) {
        FujianEntity *fujian = tA[i];
        [A addObject:fujian.fujianData];
    }
    return A;
}

//返回视频附件数组
- (NSArray *)getVideoFujiansWithFujians:(NSArray *)fujians
{
    NSMutableArray *temArray = [NSMutableArray new];
    for (FujianEntity *f in fujians) {
        if (f.type==kVideo) {
            [temArray addObject:f];
        }
    }
    return temArray;
}

//返回图片附件数组
- (NSArray *)getImageFujiansWithFujians:(NSArray *)fujians
{
    NSMutableArray *temArray = [NSMutableArray new];
    for (FujianEntity *f in fujians) {
        if (f.type==kImage) {
            [temArray addObject:f];
        }
    }
    return temArray;
}

//返回附件是否包含视频
- (BOOL)ishasVideoWithFujians:(NSArray *)fujians
{
    BOOL ret = NO;
    do {
        for (FujianEntity *f in fujians) {
            if (f.type==kVideo) {
                ret = YES;
                break;
            }
        }
    } while (0);
    return ret;
}

- (void)HidHud
{
    [self.delegate hideMHUD];
}

- (void)clean
{
    [(ViewController *)self.delegate clean];
}

@end
