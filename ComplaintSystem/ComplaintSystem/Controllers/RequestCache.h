//
//  RequestCache.h
//  XiangYangWuXian
//
//  Created by Cocoa on 14-3-7.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>
#import <CoreLocation/CoreLocation.h>

@interface RequestCache : FMDatabase

@property (nonatomic,strong) NSMutableString *sourceKey;


+ (instancetype)db;

/**
 添加一条投诉信息
 
 @param title    标题
 @param tousuren 投诉人
 @param phone    联系方式
 @param time     投诉时间
 @param address  地址
 @param location 坐标
 @param content  内容
 @param fujians  附件     字典[fid:222, data:data, type:video, size:233kb]
 @param issubmit 是否已经提交
 */
- (void)addTousuWithTitle:(NSString *)title
                 tousuren:(NSString *)tousuren
                    phone:(NSString *)phone
                     time:(NSString *)time
                  address:(NSString *)address
                 location:(CLLocationCoordinate2D)location
                  content:(NSString *)content
                  fujians:(NSArray *)fujians
                 issubmit:(int)issubmit;

//获取投诉历史记录
- (NSMutableArray *)getList;

//删除投诉历史记录 by id
- (void)deleWithID:(int)ids;

@end
