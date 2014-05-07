//
//  RequestCache.m
//  XiangYangWuXian
//
//  Created by Cocoa on 14-3-7.
//  Copyright (c) 2014年 LongYu coltd By Robin. All rights reserved.
//

#import "RequestCache.h"
#import "TousuEntity.h"
#import "LHWBase64.h"

@implementation RequestCache

+ (instancetype)db
{
    RequestCache *db = [RequestCache databaseWithPath:[RequestCache getCachePath]];
    if (![db open])
    {
        NSLog(@"数据库打开失败");
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [db CreateTable];
    });
    
    return db;
}

+ (NSString *)getCachePath
{
    NSString *path = nil;
    do {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        path = [documentDirectory stringByAppendingString:@"/cacher"];
        NSLog(@"数据库：%@",path);
    } while (false);
    return path;
}

-(void)CreateTable;
{
    if (![self open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    BOOL res = [self executeUpdate:@"CREATE TABLE IF NOT EXISTS CacheTable(id INTEGER PRIMARY KEY AUTOINCREMENT,title text,tousuren text ,phone text, time text, address text, x text, y text, content text, fujian text, issubmit text)"];
    if (!res) {
        NSLog(@"创建表失败");
    }
}

- (void)addTousuWithTitle:(NSString *)title
                 tousuren:(NSString *)tousuren
                    phone:(NSString *)phone
                     time:(NSString *)time
                  address:(NSString *)address
                 location:(CLLocationCoordinate2D)location
                  content:(NSString *)content
                  fujians:(NSArray *)fujians
                 issubmit:(int)issubmit
{
    //VIDEO {VIDEOPATH:@"",SIZE:@"20m"}|||@"dasdafdsfdgnfdgdmgfd,mng,mfdngm,fdng,mfdgfdgdf"|||
    
    do {
        CCBREAK_IF(! [self open] );
        
        NSMutableString *string = [NSMutableString stringWithString:@""];
        int i = 0;
        for (FujianEntity *fujianE in fujians) {
            
            if (i==0) {
                if (fujianE.type==kVideo) {
                    //{VIDEOPATH:@"",SIZE:@"20m"}
                    NSString *videoString = STRINGFMT(@"{VIDEOPATH:%@,SIZE:%@}",fujianE.fujianData,fujianE.size);
                    
                    [string appendString:videoString];
                }
                else
                {
                    [string appendFormat:@"%@",fujianE.fujianData];
                }
            }
            else
            {
                if (fujianE.type==kVideo) {
                    //{VIDEOPATH:@"",SIZE:@"20m"}
                    NSString *videoString = STRINGFMT(@"|||{\"VIDEOPATH\":\"%@\",\"SIZE\":\"%@\"}",fujianE.fujianData,fujianE.size);
                    
                    [string appendString:videoString];
                }
                else
                {
                    [string appendFormat:@"|||%@",fujianE.fujianData];
                }
            }
            
            i++;
        }
        
        [self executeUpdate:@"insert into CacheTable (title,tousuren,phone,time, address, x , y, content, fujian, issubmit) values (?,?,?,?,?,?,?,?,?,?)",title,tousuren,phone,time,address,STRINGFMT(@"%f",location.latitude),STRINGFMT(@"%f",location.longitude),content,STRINGFMT(@"%@",string),STRINGFMT(@"%d",issubmit)];
        
        [self close];
    } while (0);
}

- (void)deleWithID:(int)ids
{
    do {
        CCBREAK_IF(! [self open] );
        [self executeUpdate:STRINGFMT(@"DELETE FROM CacheTable WHERE id=%d",ids)];

        [self close];
    } while (0);
}

- (NSMutableArray *)getList
{
    NSMutableArray *list = nil;
    do {
        CCBREAK_IF(! [self open] );
        
        list = [NSMutableArray new];
        
        FMResultSet *rs = [self executeQuery:@"SELECT * FROM CacheTable"];
        while ([rs next]){
            int ids  = [rs intForColumn:@"id"];
            NSString *title = [rs stringForColumn:@"title"];
            NSString *phone = [rs stringForColumn:@"phone"];
            NSString *time = [rs stringForColumn:@"time"];
            NSString *toisuren = [rs stringForColumn:@"tousuren"];
            NSString *address = [rs stringForColumn:@"address"];
            double x = [string([rs stringForColumn:@"x"]) doubleValue];
            double y = [string([rs stringForColumn:@"y"]) doubleValue];
            
            NSString *content = [rs stringForColumn:@"content"];
            
            NSString *fujians = [rs stringForColumn:@"fujian"];
            
            int issubmit = [[rs stringForColumn:@"issubmit"] intValue];
            
            NSArray *array = [fujians componentsSeparatedByString:@"|||"];
            
            NSMutableArray *a = [NSMutableArray new];
            for (int i=0; i<array.count; i++) {
                NSString *data = array[i];
                if (!SAFE_STRING(data)) {
                    continue;
                }
                FujianEntity *fujianE = [FujianEntity new];
                
                //如果包含 {VIDEOPATH: 就为视屏
                if ([self isContinString:data]) {
                    NSError *error = nil;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                    if (error) {
                        cout(@"JSON解析失败");
                    }
                    else
                    {
                        fujianE.fujianData = string(dic[@"VIDEOPATH"]);
                        fujianE.type = kVideo;
                        fujianE.size = string(dic[@"SIZE"]);
                    }
                }
                else
                {
                    //图片
                    fujianE.fujianData = data;
                    fujianE.type = kImage;
                }
                
                [a addObject:fujianE];
            }
            
            TousuEntity *tousu = [TousuEntity new];
            tousu.ids = ids;
            tousu.title = title;
            tousu.phone = phone;
            tousu.time = time;
            tousu.tousuren = toisuren;
            tousu.address = address;
            tousu.location = CLLocationCoordinate2DMake(x, y);
            tousu.content = content;
            tousu.fujian = [a copy];
            tousu.isSubmit = issubmit;
            
            [list insertObject:tousu atIndex:0];
        }
        
    } while (0);
    
    [self close];
    
    return list;
}


- (BOOL)isContinString:(NSString *)string
{
    BOOL ret = YES;
    do {
        NSRange range = [string rangeOfString:@"{\"VIDEOPATH"];//判断字符串是否包含
        if (range.location ==NSNotFound)//不包含
            //        if (range.length >0)//包含
        {
            return NO;
        }
        
    } while (0);
    
    return ret;
}

- (NSString *)getCache
{
    NSLog(@"缓存%@",self.sourceKey);
    if (!self.sourceKey) {
        return nil;
    }
    //获取数据
    NSString *content = nil;
    
    if ([self open]) {
        FMResultSet *rs = [self executeQuery:@"SELECT * FROM CacheTable WHERE key=?",self.sourceKey];
        while ([rs next]){
            content = [rs stringForColumn:@"data"];
        }
        [rs close];
        [self close];
    }
    NSLog(@"缓存%@,",content);
    return content;
}
@end
