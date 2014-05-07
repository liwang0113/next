//
//  Common.m
//  dz
//
//  Created by yu Andy on 13-8-5.
//  Copyright (c) 2013年 王 敬灿. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (NSString *)getUID
{
    NSString *uid = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    uid = [user objectForKey:@"uid"];
    return uid;
}

+ (BOOL)hadLoginWithUid:(NSString*)uid
            andUserName:(NSString *)uname
{
    if (!uid)
        return NO;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"1" forKey:@"isLogin"];
    [user setValue:uname forKey:@"uname"];
    [user setValue:uid forKey:@"uid"];
    [user synchronize];
    return YES;
}

+ (void)hadLogout
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:@"isLogin"];
    [user setValue:@"" forKey:@"uname"];
    [user synchronize];
}

+ (BOOL)isLogin
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    int uid = [[user objectForKey:@"isLogin"] intValue];
    if (uid==1)
        return YES;
    else
        return NO;
}
#pragma mark  手机邮箱合法验证
/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//#pragma mark - ylg make
//#pragma mark MD5加密
//+ (NSString *)md5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}

//+ (NSString *)getKeyCode
//{
//    NSString *skey = [self md5:TIMESTR];
//    return skey;
//}

- (void)setString:(id)object withstr:(NSString *)str
{

}

+ (NSMutableArray *)dicToArray:(NSArray *)arr andKey:(NSString *)key
{
    if (!arr && !key)return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i=0; i<[arr count]; i++) {
        id object = [[arr objectAtIndex:i] objectForKey:@"key"];
        [array addObject:object];
    }
    return array;
}

void setString(id object,NSString* str)
{
    if (!object) return;
    if (!str) return;
    if (str == nil || str == NULL) {
        return;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return;
    }
    @try {
        if ([object isKindOfClass:[UILabel class]] || [object isKindOfClass:[UITextField class]]) {
            [object setText:str];
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            object = str;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return;
    }
}

+ (void)alert:(NSString*)title :(NSString*)content andDelegate:(id)_self
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:_self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (NSDate*)dateFromUnixTimestamp:(NSTimeInterval)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

#pragma mark 1页有多少数量
+(NSInteger)getPageNum:(NSInteger)count size:(NSInteger)size page:(NSInteger)page
{
    NSInteger pageNum=[self getPageSize:count size:size];
    if (page>pageNum) {
        return 0;
    }else{
        //最后1页
        if (page==pageNum) {
            if(count < (size*page)){
                return (count-size*(page-1));
            }else if(count == (size*page)){
                return size;
            }
        }else{
            //其他的
            return size;
        }
    }
    return 0;
}
#pragma mark 得到共几页
+(NSInteger )getPageSize:(NSInteger)count size:(NSInteger)size
{
    if (size==0) {
        size=1;
    }
    double p=(double)count/size;
    double page= round(count/size);
    
    //如果有余则累加1
    if (p>page) {
        page+=1;
    }
    return page;
}
+(NSString *)stringTOjson:(id)idss   //把字典和数组转换成json字符串
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:idss
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}
+(NSArray *)jsonTOArrays:(NSString*)string
{
    NSString *temp=[string stringByReplacingOccurrencesOfString:@"\\" withString:@""] ;
    NSData *data = [temp dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return jsonArray;
}
//转换UTF8
+(NSString *)stringToUTF8:(NSString *)string
{
    NSString *url=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}
#pragma mark -
#pragma mark 分页
+(UIPageControl *)pageControlView:(CGRect )f count:(NSInteger )count
{
    UIPageControl *index_pageControl = [[UIPageControl alloc] initWithFrame:f] ;
    //    index_pageControl.pageIndicatorTintColor = [UIColor colorWithRed:237.0f/255.0f green:110.0f/255.0f blue:0.0f/255.0f alpha:1.0f];//ad_point
    index_pageControl.numberOfPages = count;
    index_pageControl.currentPage = 0;
    index_pageControl.selected = YES;
    return index_pageControl;
}
#pragma mark -
#pragma mark 图片缓存
+(NSString *)saveImage:(NSString *)imgStr
{
    NSString  *imagePath = [[self createImagePaths] stringByAppendingFormat:@"/%@", imgStr];
    return imagePath;
}

#pragma mark 获取Cache路径
+ (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    return path;
}

#pragma mark 创建存储图片的路径
+ (NSString *)createImagePaths
{
    NSArray *segments = [NSArray arrayWithObjects:[self getCachePath], @"image", nil];
    
    NSString *imgfilePath =  [NSString pathWithComponents:segments];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    [fileManager createDirectoryAtPath:imgfilePath withIntermediateDirectories:YES attributes:nil error:&error];
    
    return imgfilePath;
}

+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
+(UIImage *)getAvatar:(NSString *)url
{
    NSData *imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:imageData];
}

+(UIFont *)getFont
{
    //    return [UIFont fontWithName:@"Arial" size:16.0f];
    UIFont *font= [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    return font;
}

+(NSMutableArray *)getTableArry:(id)datas myArry:(NSMutableArray *)arrs totalPage:(int )totalPages clomMax:(int)clomMax pageRow:(int)rows requstNumber:(int )requstNumbers signString:(NSString *)ids;
{
    NSMutableArray *temps=[[NSMutableArray alloc]init];
    for (int i=0; i<[arrs count]; i++) {
        [temps addObject:[arrs objectAtIndex:i]];
    }
    if (rows==1) {
        [arrs removeAllObjects];
        //移除重复的
        for (int i=0; i<[datas count]; i++) {
            id tempDic=[datas objectAtIndex:i];
            if ([temps count]>0) {
                for (int j=0; j<[temps count]; j++) {
                    NSMutableDictionary *tempDics=[temps objectAtIndex:j];
                    if ([[tempDics objectForKey:ids]isEqualToString:[tempDic objectForKey:ids]]) {
                        [temps removeObject:tempDics];
                        //                            [temps removeObjectAtIndex:j];
                    }
                }
            }
            [arrs addObject:tempDic];
        }
        //添加原有的
        if ([temps count]>0) {
            for (int i=0; i<[temps count]; i++) {
                [arrs addObject:[temps objectAtIndex:i]];
            }
        }
    }
    else
    {
        for (int i=0; i<[datas count]; i++) {
            id tempDic=[datas objectAtIndex:i];
            if ([temps count]>0) {
                for (int j=0; j<[temps count]; j++) {
                    NSMutableDictionary *tempDics=[temps objectAtIndex:j];
                    if ([tempDics objectForKey:ids]==[tempDic objectForKey:ids]) {
                        [temps removeObjectAtIndex:j];
                    }
                }
            }
            [arrs addObject:tempDic];
        }
    }
    return arrs;
}

//获取当前日期+时间
+(NSString *)getCurrentDateTime{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
//获取当前日期  20130506格式
+(NSString *)getDateTimes{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
//获取当前日期  20130506格式
+(NSString *)getDates{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
//获取当前日期
+(NSString *)getCurrentDate{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
//获取当前日期
+(NSString *)converStringFromDate:(NSDate *)dates{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:dates];
    return destDateString;
}
//日期转换成date类型
+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
/**************时间转化格式不同**************/
+(NSString *)getCurrentDate1Time{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
//获取当前日期
+(NSString *)converStringFromDateTime:(NSDate *)dates{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:dates];
    return destDateString;
}
//日期转换成date类型
+(NSDate*) convertDateTimeFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
/**************时间转化格式不同**************/
/**********判断时间周期 昨天 今天 或者 更早  用于消息列表的显示************/
+(NSString *)judgeDatacycle:(NSString *)timeString
{
    NSDate *timedate=[self convertDateTimeFromString:timeString];
    //用于展示时间 只显示分
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter1 setDateFormat:@"HH:mm"]; //上午 10:00
    NSString *showtimeString = [dateFormatter1 stringFromDate:timedate];
    
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];// 2013-6-16
    NSString *showDateString=[dateFormatter2 stringFromDate:timedate];
    
    
    NSTimeInterval timeValue = [timedate timeIntervalSince1970];
    //计算得到是时间 是否为今天
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    destDateString=[destDateString stringByAppendingString:@" 00:00"];
    NSDate *todayDate=[self convertDateTimeFromString:destDateString];
    NSTimeInterval todayDateValue = [todayDate timeIntervalSince1970];
    
    //判断在昨天之前
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *earlyDate=[todayDate dateByAddingTimeInterval:-secondsPerDay];
    NSTimeInterval earlyDateValue = [earlyDate timeIntervalSince1970];
    if((long long int)todayDateValue < (long long int)timeValue)
    {
        showtimeString=[NSString stringWithFormat:@"今天 %@",showtimeString];
    }
    
    else if((long long int)earlyDateValue < (long long int)timeValue && (long long int)todayDateValue > (long long int)timeValue )
    {
        showtimeString=[NSString stringWithFormat:@"昨天 %@",showtimeString];
    }
    else{
        showtimeString=[NSString stringWithFormat:@"%@",showDateString];
    }
    return showtimeString;
}
#pragma mark -根据日期获取周几
+(NSString*)weekDays:(NSString *)dateString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dates=[self convertDateFromString:dateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:dates];
    int  week = [comps weekday];
    switch (week) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        default:
            return @"星期六";
            break;
    }
}

#pragma mark - 随机数
+(NSInteger )getRandom
{
    return random();
}

#pragma mark -拍照旋转
+(UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 600; //PUT YOUR DESIRED RESOLUTION HERE
    
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

//获取文字的高度
+ (float)getTextHeightWithString:(NSString*)string
                            font:(UIFont *)font
                        andWidth:(float)width;
{
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string
                                                                             attributes:attributes];
        
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        
        return size.height;
    }
#endif
    CGSize siz = [string sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return siz.height;
}

+(NSMutableArray*)emotionKeysFrom:(NSString *)messages
{
    NSMutableArray *substrings = [NSMutableArray new];
    NSScanner *scanner = [NSScanner scannerWithString:messages];
    [scanner scanUpToString:@"<#f" intoString:nil];
    while(![scanner isAtEnd]) {
        NSString *substring = nil;
        [scanner scanString:@"<#f" intoString:nil];
        if([scanner scanUpToString:@">" intoString:&substring]) {
            
            [substrings addObject:substring];
        }
        [scanner scanUpToString:@"<#f" intoString:nil];
    }
    return substrings;
}

+ (NSDictionary *)emotions
{
    static NSDictionary *dic;
    if (!dic) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Emoticons" ofType:@"plist"];
        dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return dic;
}

+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

NSString* string(NSString* str)
{
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    @try {
        if ([Common isBlankString:str]) {
            return @"";
        }
        return str;
    }
    @catch (NSException *exception) {
        
    }
}

//是否都是字母或数字
bool isLetterAndNum(NSString *str)
{
    NSArray *StrArr = [str componentsSeparatedByString:@""];
    for (int i=0; i<StrArr.count; i++) {
        NSString *strExp=@"/^[A-Za-z0-9]+$/";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strExp];
        BOOL isMatch = [pred evaluateWithObject:StrArr[i]];
        if (!isMatch) {
            NSLog(@"中文");
            return false;
        }
    }
    NSLog(@"全是数字和字母");
    return true;
}

//判断是否是中文  这样的确可以判断大多数中文符号，但是少数字符比如句号“。”在unichar存储的16进制值要小于0x4e00，查了很多资料试了很多例子发现只有这样判断才是正确的：
bool isChiness(NSString *str)
{
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            return true;
        }
    }
    return false;

}

NSString* string__If__empty(NSString* string)
{
    if([Common isBlankString:string])
        return @"0";
    else
        return string;
}

+ (NSMutableArray *)arrayTo:(NSMutableArray *)arr1 AddArray:(NSMutableArray *)arr2
{
    if (!arr1) {
        if (!arr2) {
            return nil;
        }
        return arr2;
    }
    if (!arr2) {
        return arr1;
    }
    
    NSMutableArray *temArray = [NSMutableArray arrayWithArray:arr1];
    [temArray addObjectsFromArray:arr2];
    return temArray;
}

+ (float)getFontSize
{
    NSString *size = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontsize"];
    return [size floatValue];
}
+ (NSString *)getDateString
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    return dateString;
}

@end


