//
//  SCHTTPSessionManager.m
//  CDOTO
//
//  Created by yier on 16/3/29.
//  Copyright © 2016年 newdoone. All rights reserved.
//

#import "SCHTTPSessionManager.h"

@implementation SCHTTPSessionManager

+(instancetype)shareInstance
{
    static  SCHTTPSessionManager * _SCHTTPSessionManager = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _SCHTTPSessionManager  = [[self alloc] init] ;
        _SCHTTPSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _SCHTTPSessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        //_SCHTTPSessionManager.securityPolicy.allowInvalidCertificates = YES;
        [_SCHTTPSessionManager.requestSerializer setTimeoutInterval:10];
        _SCHTTPSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];//如果报接受类型不一致请替换一致text/html或别的

    });
    
    return _SCHTTPSessionManager ;
}
//离线访问缓存数据 在线则请求
//        AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];;
//        [reachability startMonitoring];
//        [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//
//            switch (status) {
//                case AFNetworkReachabilityStatusNotReachable:{
//                     _SCHTTPSessionManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//
//                    break;
//                }
//                case AFNetworkReachabilityStatusReachableViaWiFi:{
//
//                    break;
//                }
//
//                case AFNetworkReachabilityStatusReachableViaWWAN:{
//
//                    break;
//                }
//                default:
//                    break;
//            }
//
//        }];

@end
