
//打印
#pragma mark ---log  flag
#define LogFrame(frame) NSLog(@"frame[X=%.1f,Y=%.1f,W=%.1f,H=%.1f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
#define LogPoint(point) NSLog(@"Point[X=%.1f,Y=%.1f]",point.x,point.y)


#define DDDLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#ifdef DEBUG
#	define echo(fmt) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__);
#else
#	define echo(...) do{}while(0)
#endif

#ifdef DEBUG
#define cout(fmt,...)  NSLog(fmt,##__VA_ARGS__);
#else
#	define cout(...) do{}while(0)
#endif

#ifdef	_DEBUG
#define	DNSLog(...);	NSLog(__VA_ARGS__);
#define DNSLogMethod	NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
#define DNSLogPoint(p)	NSLog(@"%f,%f", p.x, p.y);
#define DNSLogSize(p)	NSLog(@"%f,%f", p.width, p.height);
#define DNSLogRect(p)	NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);
#endif

//view log
#ifdef VIEW_BLOCK_LOG
#define LogVIEW DDDLog
#else
#define LogVIEW
#endif

#pragma mark --time setup
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#endif

#define SAFE_FREE(p) { if(p) { free(p); (p)=NULL; } }

//方法宏
#pragma mark ---- AppDelegate
//AppDelegate
#define APPDELEGATE [(Director*)[UIApplication sharedApplication]  delegate]
//UIApplication
#define APPD  [UIApplication sharedApplication]
#define rootNavVC (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]

#define isPad  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define isiPhone5 ([[UIScreen mainScreen]bounds].size.height == 568)
#define ISIOS7 [[[UIDevice currentDevice]systemVersion] doubleValue] >= 7.0

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#pragma mark ---- String  functions
#define EMPTY_STRING        @""
#define STR(key)            NSLocalizedString(key, nil)

#pragma mark ---- UIImage  UIImageView  functions
#define IMG(name) [UIImage imageNamed:name]
#define IMGF(name) [UIImage imageNamedFixed:name]
#define IMGFILE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]

#pragma mark ---- File  functions
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark ----Size ,X,Y, View ,Frame
//get the  size of the Screen
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define HEIGHT_SCALE  ([[UIScreen mainScreen]bounds].size.height/480.0)
#define SCREEN [[UIScreen mainScreen]bounds]

//get the  size of the Application
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width

#define APP_SCALE_H  ([[UIScreen mainScreen]applicationFrame].size.height/480.0)
#define APP_SCALE_W  ([[UIScreen mainScreen]applicationFrame].size.width/320.0)

//get the left top origin's x,y of a view
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)

//get the width size of the view:width,height
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//get the right bottom origin's x,y of a view
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height )

//get the x,y of the frame
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)
//get the size of the frame
#define FRAME_W(frame)  (frame.size.width)
#define FRAME_H(frame)  (frame.size.height)

#define DistanceFloat(PointA,PointB) sqrtf((PointA.x - PointB.x) * (PointA.x - PointB.x) + (PointA.y - PointB.y) * (PointA.y - PointB.y))

//iphone5判断
#ifndef DEVICE_IS_IPHONE5
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#endif

//iphone4判断
#ifndef DEVICE_IS_IPHONE4
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#endif

//颜色
#define  COLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define COLORRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//字体
//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//ARC
#if __has_feature(objc_arc)
#define ISARC 0
#else
#define ISARC 1
#endif

//String
#define STRINGFMT(fmt,...) [NSString stringWithFormat:fmt,##__VA_ARGS__]

//G－C－D
#define LHWBACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define LHWMAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#define TIMESTR \
    [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

#define ALERT_MSG(msg) \
UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alerts show];

#define INT(str) [str intValue]
//#define UUID [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceID"]
#define VALUE(pDic,key) [pDic valueForKey:key]
#define SETVALUE(pDic,value,key) if (pDic)[pDic setValue:value forKey:key]


#define SAFE_ARRAY(array) (array && [array isKindOfClass:[NSArray class]] && array.count>0) ? 1 :0

#define SAFE_STRING(string) (string && ![Common isBlankString:string] && [string isKindOfClass:[NSString class]]) ? 1 :0


#define CCBREAK_IF(where) if (where) break;



