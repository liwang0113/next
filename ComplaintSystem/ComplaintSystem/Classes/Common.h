//
//  config.h
//  config file
//
//  Created by user on 12-2-21.
//  Copyright 2012年 machs. All rights reserved.

#import <Foundation/Foundation.h>
#import "CommonFunction.h"

#import "BaseViewController.h"
#import "LHWRequest.h"


//________________________________工程配置___________________________________
//接口链接地址
#ifndef kWebServerURL
#define kWebServerURL                   @"http://test.fdserve.com/complaint/ComplaintService.asmx"
#endif

#ifndef kLocationWebServerURL
#define kLocationWebServerURL           @"http://test.fdserve.com/complaint/ComplaintService.asmx"
#endif
#define kDefaultWebServiceNameSpace     @"http://tempuri.org/"


#ifndef USERID
#define KEYCODE [Common getKeyCode]
#endif
#ifndef USERID
#define USERID [Common getUID]
#endif

#ifndef USER_LAT
#define USER_LAT [DataModel sharedDataModel].latitude
#define USER_LNG [DataModel sharedDataModel].longitude
#endif

#define ISENPTYSTRING(STR) [Common isBlankString:STR]

#define STRING_0(STR) string__If__empty(STR)

@interface Common : NSObject
{

}

//+ (NSString *)getKeyCode;
+ (NSString *)getUID;
+ (BOOL)hadLoginWithUid:(NSString*)uid andUserName:(NSString *)uname;
+ (void)hadLogout;
+ (BOOL)isLogin;
+ (BOOL)isBlankString:(NSString *)string;
+ (void)alert:(NSString*)title :(NSString*)content andDelegate:(id)_self;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL) isValidateMobile:(NSString *)mobile;
+ (NSInteger)getPageNum:(NSInteger)count size:(NSInteger)size page:(NSInteger)page;  //1页有多少数量
//获取当前日期  20130506格式
+ (NSString *)getDates;
+ (NSInteger )getPageSize:(NSInteger)count size:(NSInteger)size;  //得到共多少页
+ (UIPageControl *)pageControlView:(CGRect )f count:(NSInteger )count;//分页
+ (NSString *)saveImage:(NSString *)imgStr;//保存图片
+ (NSDate*)dateFromUnixTimestamp:(NSTimeInterval)timestamp;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;  //拍照旋转
+ (NSString *)converStringFromDate:(NSDate *)dates; //date类型转换成日期字符串
+ (NSString *)getCurrentDateTime;//获取当前日期+时间
+ (NSString *)getCurrentDate;//获取当前日期
+ (NSString *)getCurrentDate1Time;
+ (NSString *)converStringFromDateTime:(NSDate *)dates;

+ (NSDate*) convertDateTimeFromString:(NSString*)uiDate;
+ (NSString *)judgeDatacycle:(NSString *)timeString; //判断时间周期
+ (NSArray *)jsonTOArrays:(NSString*)string;
+ (NSString *)stringToUTF8:(NSString *)string;
+ (NSString*)weekDays:(NSString *)dateString; //根据日期获取星期几
+ (NSDate*) convertDateFromString:(NSString*)uiDate; //string类型日期转换成date类型
+ (NSString *)stringTOjson:(id)idss;   //把字典和数组转换成json字符串

+ (NSString *)getDateTimes;
//获取最新的数据集
+ (NSMutableArray *)getTableArry:(id)datas myArry:(NSMutableArray *)arrs totalPage:(int )totalPages clomMax:(int)clomMax pageRow:(int)rows requstNumber:(int )requstNumbers signString:(NSString *)ids;
+ (UIImage *)getAvatar:(NSString *)url;
+ (UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;
+ (float)getTextHeightWithString:(NSString*)string
                            font:(UIFont *)font
                        andWidth:(float)width;
+ (NSMutableArray *)dicToArray:(NSArray *)arr andKey:(NSString *)key;

void setString(id,NSString*);
+ (UIColor *)getColor:(NSString *)hexColor;
NSString* string(NSString*);
bool isLetterAndNum(NSString*);
bool isChiness(NSString*);
NSString* string__If__empty(NSString*);

+ (NSMutableArray *)arrayTo:(NSMutableArray *)arr1 AddArray:(NSMutableArray *)arr2;

+ (float)getFontSize;
+ (NSString *)getDateString;

@end










