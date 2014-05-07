//
//  LHWRequest.h
//  dz
//
//  Created by yu Andy on 13-8-5.
//  Copyright (c) 2011年 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

#define SHOW_DEBUG_MESSAGE 0

//创建GET请求对象
#define CREATE_GET(PARAMETER) \
[[LHWRequest alloc] initWithBaseURL:nil andParameters:PARAMETER]

#define CREATE_GET_URL(URL,PARAMETER) \
[[LHWRequest alloc] initWithBaseURL:URL andParameters:PARAMETER]

//创建POST请求对象
#define CREATE_POST() \
[[LHWRequest alloc] initWithURL:nil]

#define CREATE_POST_URL(URL) \
[[LHWRequest alloc] initWithURL:URL]


#define CREATE_WEB_SER(URL,METHOD,PARAMETER) \
[[LHWRequest alloc] initWithWebServiceURL:URL methodName:METHOD andParameters:PARAMETER]

//添加post参数
#define POST(request,value,key) \
if (!request) return;\
[request addPostValue:value         forKey:key]

@class LHWRequest;
enum REQUEST_TYPE {
    TYPE_POST = 0,
    TYPE_GET,
    TYPE_WEBSER,
    };
typedef enum REQUEST_TYPE kRequest_type;

typedef void (^requestSuccessBlock)(LHWRequest*,id);// = ^(int request,id response){};
typedef void (^requestFailureBlock)(LHWRequest*,NSError*);// = ^(int request,NSError *error);

@interface LHWRequest : ASIFormDataRequest

@property (nonatomic,assign)    int                 requestIndex;
@property (nonatomic,strong)    NSMutableDictionary *requestParameters;
@property (nonatomic,readonly)  NSDictionary        *respondDic;
@property (nonatomic,assign)    BOOL                isCheckNetWord;
@property (nonatomic,strong)    NSString            *methodName;
@property (nonatomic,assign,readonly) kRequest_type  request_type;

@property (nonatomic,copy) requestSuccessBlock  successBlock;
@property (nonatomic,copy) requestFailureBlock  failureBlock;

@property (nonatomic,assign) BOOL  isUseCache;
@property (nonatomic,strong) NSString*  cacheData;
/**
 *POST请求方式
 *@param newURL      链接
 *@return 返回请求对象实例
 */
- (id)initWithURL:(NSURL *)newURL;


- (id)initWithWebServiceURL:(NSURL *)newURL
                 methodName:(NSString *)method
              andParameters:(NSDictionary *)parameters
                success:(requestSuccessBlock)successBlock
                    failure:(requestFailureBlock)failureBlock;



- (id)initWithWebServiceURL:(NSURL *)newURL
                 methodName:(NSString *)method
              andParameters:(NSDictionary *)parameters;

- (void)setSuccess:(requestSuccessBlock)successBlock
                    failure:(requestFailureBlock)failureBlock;
/**
 *GET请求方式
 *@param baseURL      链接
 *@param parameters   请求参数
 *@return 返回请求对象实例
 */

- (id)initWithBaseURL:(NSURL *)baseURL
        andParameters:(NSDictionary *)parameters;


/**
 *post快捷方式
 *@return 返回请求对象实例
 */

+ (instancetype)post;



/**
 *get快捷方式
 *@return 返回请求对象实例
 */

+ (instancetype)get:(NSDictionary *)parameters;

@end

extern NSString * LHWQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding encoding);

