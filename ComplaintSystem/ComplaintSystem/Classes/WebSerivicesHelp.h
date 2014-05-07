//
//  WebSerivicesHelp.h
//  XiangYangWuXian
//
//  Created by yu Andy on 14-2-21.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSerivicesHelp : NSObject

+(NSMutableURLRequest*)commonRequestUrl:(NSString*)wsUrl nameSpace:(NSString*)space methodName:(NSString*)methodname soapMessage:(NSString*)soapMsg;

@end
