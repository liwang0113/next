//
//  TousuEntity.h
//  ComplaintSystem
//
//  Created by yu Andy on 14-4-3.
//  Copyright (c) 2014年 longyu_coltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TousuEntity : NSObject
@property (nonatomic, assign) int ids;
//回执
@property (nonatomic, strong) NSString *replay;

//标题
@property (nonatomic, strong) NSString *title;
//联系方式
@property (nonatomic, strong) NSString *phone;
//投诉时间
@property (nonatomic, strong) NSString *time;
//投诉地址
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *tousuren;
@property (nonatomic, assign) CLLocationCoordinate2D location;

//投诉内容
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSMutableArray *fujian;

@property (nonatomic, assign) int   isSubmit;

@end

enum FuJianType
{
    kVideo,
    kImage
};

typedef enum FuJianType  Type;

@interface FujianEntity : NSObject

@property (nonatomic, assign) int fid;
//回执
@property (nonatomic, strong) NSString *fujianData;

@property (nonatomic, strong) NSData   *data;

@property (nonatomic, assign) Type      type;

@property (nonatomic, strong) NSString  *size;
@end
