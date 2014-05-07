//
//  LHWRequest.m
//  dz
//
//  Created by yu Andy on 13-8-5.
//  Copyright (c) 2011年 Robin. All rights reserved.
//

#import "LHWRequest.h"
#import "CommonFunction.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "SoapHelper.h"
#import "SoapXmlParseHelper.h"

@implementation LHWRequest

@synthesize failureBlock = _failureBlock;
@synthesize successBlock = _successBlock;

- (id)initWithBaseURL:(NSURL *)baseURL
        andParameters:(NSDictionary *)parameters
{
    self = [self initWithURL:[self urlWithDictionary:parameters
                                          andBaseURL:baseURL]];
    if (self)
    {
        [self setRequestMethod:@"GET"];
        self.requestParameters = [parameters copy];
        //        AppDelegate *director =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [self setDownloadCache:(id)director.cache];
        //        [self setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    return self;
}

- (id)initWithWebServiceURL:(NSURL *)newURL
                 methodName:(NSString *)method
              andParameters:(NSDictionary *)parameters
                    success:(requestSuccessBlock)successBlocks
                    failure:(requestFailureBlock)failureBlocks
{
    newURL = newURL?newURL:[NSURL URLWithString:kWebServerURL];
    self = [super initWithURL:newURL];
    if (self) {
        self.methodName = method;
        self.successBlock = successBlocks;
        self.failureBlock = failureBlocks;
        _request_type = TYPE_WEBSER;
        
        NSString *soapMsg = [SoapHelper getSoapMessageWith:parameters andMethodName:method];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
        
        //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
        [self addRequestHeader:@"Host" value:[newURL host]];
        [self addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
        [self addRequestHeader:@"Content-Length" value:msgLength];
        [self addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",kDefaultWebServiceNameSpace,method]];
        [self setRequestMethod:@"GET"];
        
        NSArray *allKeys = [parameters allKeys];
        NSArray *allValues = [parameters allValues];
        
        for (int i =0 ; i < allKeys.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [allValues objectAtIndex:i];
            [self addPostValue:value forKey:key];
        }
        self.delegate = self;
        
        //设置用户信息
        [self setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:method,@"name", nil]];
        //传soap信息
        [self appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        [self setValidatesSecureCertificate:NO];
        [self setTimeOutSeconds:30.0];//表示30秒请求超时
        [self setDefaultResponseEncoding:NSUTF8StringEncoding];
    }
    return self;
}

- (id)initWithWebServiceURL:(NSURL *)newURL
                 methodName:(NSString *)method
              andParameters:(NSDictionary *)parameters
{
    newURL = newURL?newURL:[NSURL URLWithString:kWebServerURL];
    self = [super initWithURL:newURL];
    if (self) {
        self.methodName = method;
        self.isUseCache = NO;
        _request_type = TYPE_WEBSER;

        //如果没有网络就使用离线缓存
        if (getNetWorks()==NO) {
            self.isUseCache = YES;
            return self;
        }
        
        NSString *soapMsg = [SoapHelper getSoapMessageWith:parameters andMethodName:method];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
        
        //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
        [self addRequestHeader:@"Host" value:[newURL host]];
        [self addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
        [self addRequestHeader:@"Content-Length" value:msgLength];
        [self addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",kDefaultWebServiceNameSpace,method]];
        [self setRequestMethod:@"POST"];
        
        self.delegate = self;
        
        //设置用户信息
        [self setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:method,@"name", nil]];
        //传soap信息
        [self appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        [self setValidatesSecureCertificate:NO];
        [self setTimeOutSeconds:30.0];//表示30秒请求超时
        [self setDefaultResponseEncoding:NSUTF8StringEncoding];
        
    }
    return self;
}

//设置成功和失败回调
- (void)setSuccess:(requestSuccessBlock)successBlocks
           failure:(requestFailureBlock)failureBlocks
{
    self.successBlock = successBlocks;
    self.failureBlock = failureBlocks;
}

//请求成功回调
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (!_successBlock) {
        return;
    }
    //成功回调
    self.successBlock(self,self.respondDic);
}

//请求失败回调
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (!self.failureBlock) {
        return;
    }
    //回调失败
    self.failureBlock(self,self.error);
}

- (void)debug
{
    #if SHOW_DEBUG_MESSAGE
    NSArray *array = [self.requestParameters allKeys];
    NSArray *array2 = [self.requestParameters allValues];
    NSString *str = @"";
    for (int i=0; i<array.count; i++) {
        str = [str stringByAppendingFormat:@"%@=>   %@\n",array[i],array2[i]];
    }
    cout(@"参数:%@",str);
    #endif
}

+ (instancetype)post
{
    return [[LHWRequest alloc] initWithURL:nil];
}

+ (instancetype)get:(NSDictionary *)parameters
{
    return [[LHWRequest alloc] initWithBaseURL:nil andParameters:parameters];
}

- (id)initWithURL:(NSURL *)newURL
{
    self.requestParameters = [NSMutableDictionary new];
    NSURL *baseURL = newURL;
    if (!baseURL || ![baseURL isKindOfClass:[NSURL class]]) {
        baseURL = [NSURL URLWithString:kWebServerURL];
    }
    self = [super initWithURL:baseURL];
    if (!self)
        return nil;
    return self;
}

//添加POST
- (void)addPostValue:(id<NSObject>)value forKey:(NSString *)key
{
    [super addPostValue:value forKey:key];
    [self.requestParameters setValue:value forKey:key];
}

//开始同步请求
- (void)startSynchronous
{
    [self debug];
    
    [super startSynchronous];
}

//开始异步请求
- (void)startAsynchronous
{
    [self debug];
    
    [super startAsynchronous];
}

//解析数据JSON数据
- (NSDictionary *)respondDic
{
    #if SHOW_DEBUG_MESSAGE
    cout(@"返回内容:%@",self.responseString);
    #endif
    
    NSData *data;
    
    //如果是WEBService请求
    if (self.request_type==TYPE_WEBSER) {
        NSString *results=[[SoapXmlParseHelper SoapMessageResultXml:self.responseString ServiceMethodName:[self.methodName stringByAppendingString:@"Result"]] copy];
        NSDictionary *d = [NSDictionary dictionaryWithObject:results forKey:@"result"];
        return d;
        
    }
    else
    {
        data = self.responseData;
    }
    
    
    NSError *errors = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableLeaves
                                               error:&errors];
    
    if (errors) {
        printf("JSON解析失败，请确认是否为JSON格式");
    }
    return dic;
}

//获取网络
bool getNetWorks()
{
    NetworkStatus theState;
    BOOL haveNetwork = YES;
    Reachability *netsWork = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([netsWork currentReachabilityStatus]) {
        case NotReachable:
            haveNetwork=NO;
            theState = NotReachable;
            break;
        case ReachableViaWWAN:
            haveNetwork=YES;
            theState = ReachableViaWWAN;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            haveNetwork=YES;
            theState = ReachableViaWiFi;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
    return haveNetwork;
}

- (NSURL *)urlWithDictionary:(NSDictionary *)dic
                  andBaseURL:(NSURL *)baseurl
{
    NSURL *urls = nil;
    if (!dic) {
        return baseurl;
    }
    NSString *path = [baseurl path];
    urls = [NSURL URLWithString:[[baseurl absoluteString] stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", LHWQueryStringFromParametersWithEncoding(dic, NSUTF8StringEncoding)]];
    return urls;
}

@end
static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

#pragma mark -

@interface LHWQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

@implementation LHWQueryStringPair
@synthesize field = _field;
@synthesize value = _value;

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return AFPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", AFPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.field description], stringEncoding), AFPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.value description], stringEncoding)];
    }
}


@end

#pragma mark -

extern NSArray * LHWQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSArray * LHWQueryStringPairsFromKeyAndValue(NSString *key, id value);

NSString * LHWQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding)
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (LHWQueryStringPair *pair in LHWQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * LHWQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return LHWQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * LHWQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue =[dictionary objectForKey:nestedKey];
            //dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:LHWQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:LHWQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in set) {
            [mutableQueryStringComponents addObjectsFromArray:LHWQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[LHWQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}


