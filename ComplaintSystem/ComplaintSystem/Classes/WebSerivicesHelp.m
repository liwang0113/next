//
//  WebSerivicesHelp.m
//  XiangYangWuXian
//
//  Created by yu Andy on 14-2-21.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import "WebSerivicesHelp.h"
//#import "WebServices.h"


@implementation WebSerivicesHelp

+(NSMutableURLRequest*)commonRequestUrl:(NSString*)wsUrl nameSpace:(NSString*)space methodName:(NSString*)methodname soapMessage:(NSString*)soapMsg
{
    
    NSURL *url=[NSURL URLWithString:wsUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    NSString *soapAction=[NSString stringWithFormat:@"%@%@",space,methodname];
    //头部设置
    NSDictionary *headField=[NSDictionary dictionaryWithObjectsAndKeys:
                             [url host],@"Host",
                             @"text/xml; charset=utf-8",@"Content-Type",
                             msgLength,@"Content-Length",
                             soapAction,@"SOAPAction",nil];
    [request setAllHTTPHeaderFields:headField];
    //超时设置
    [request setTimeoutInterval: 5 ];
    //访问方式
    [request setHTTPMethod:@"POST"];
    //body内容
    [request setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

@end
