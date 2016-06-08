//
//  FSJNetworking.m
//  FSJ
//
//  Created by Monstar on 16/5/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJNetworking.h"

@implementation FSJNetworking
#pragma mark --GET
+(AFHTTPSessionManager *)networkingGETWithURL:(NSString *)URL
                            requestDictionary:(NSDictionary *)requestDictionary
                                      success:(void (^)(NSURLSessionDataTask *operation, NSDictionary* responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask * operation, NSError *error))failure{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSString  *getURL =[NSString stringWithFormat:@"%@%@",BaseURL,URL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager GET:getURL parameters:requestDictionary progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(task,error);
    }];
    return manager;
}
+ (AFHTTPSessionManager *)networkingGETWithActionType:(NetworkConnectionActionType)actionType
                                    requestDictionary:(NSDictionary *)requestDictionary
                                              success:(void (^)(NSURLSessionDataTask *operation, NSDictionary* responseObject))success
                                              failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSString  *URL =[NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    NSLog(@"%@",URL);
    
    [manager GET:URL parameters:requestDictionary progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        
        failure(task,error);
    }];
    return manager;
}

#pragma mark --POST
+ (AFHTTPSessionManager *)networkingPOSTWithActionType:(NetworkConnectionActionType)actionType
                                     requestDictionary:(NSDictionary *)requestDictionary
                                               success:(void (^)(NSURLSessionDataTask *operation, NSDictionary* responseObject))success
                                               failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
  
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL parameters:requestDictionary progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
//        id dict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
//        NSLog(@"获取到的数据为：%@",dict);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(task,error);
    }];
    return manager;
}
#pragma mark --上传
+ (AFHTTPSessionManager *)networkingPostIconWithActionType:(NetworkConnectionActionType)actionType
                                         requestDictionary:(NSDictionary *)requestDictionary
                                                  formdata:(void (^)(id<AFMultipartFormData>formData))data
                                                   success:(void (^)(NSURLSessionDataTask *operation,NSDictionary* responseObject))success
                                                   failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSString  *URL =[NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:URL parameters:requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
        data(formData);
    } progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
         success(task,responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
        failure(task,error);
    }];
    return manager;
}
+ (NSDictionary *)transJSONtoDic:(id)data{
    NSDictionary *responseDict ;
    if ([data isKindOfClass:[NSData class]]) {
        responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }else{
        NSLog(@"数据不是NSData数据");
        return data;
    }
    return responseDict;
}
+ (NSString *)actionWithConnectionActionType:(NetworkConnectionActionType)actionType{
    NSString *url = @"";
    switch (actionType) {
        case LoginAction:
            url = @"/rs/user/login";
            break;
        case NationalarmStatus:
            url = @"/rs/app/map/alarmStatus";
            break;
        case AreaalarmStatus:
            url = @"/rs/app/map/alarmStatus";
            break;
        case Allstationquery:
            url = @"/rs/app/map/station/transmitter/list";
            break;
        case Onestationquery:
            url = @"rs/app/map/station/transmitter/getById";
            break;
        case Keywordsquery:
            url = @"/rs/app/map/query";
            break;
        case UserInfoPreview:
            url = @"/rs/app/user/info";
            break;
        case UserInfoChange:
            url = @"/rs/app/user/updateUser";
            break;
        case UserPwdChange:
            url = @"/rs/app/user/changePassword";
            break;
        case UserIconUpload:
            url = @"/rs/user/upload/photo";
            break;
        case UserLogoutAction:
            url = @"/rs/app/user/logout";
            break;
        case GetAllManager:
            url = @"/rs/app/station/manager/list";
            break;
        case GetOneManager:
            url = @"/rs/app/station/manager/info";
            break;
        case GetGongxiao:
            url = @"/rs/app/device/transmitter";
            break;
        case GetGongxiaoDetail:
            url = @"/rs/app/device/amparam";
            break;
        case GetZhengji:
            url = @"/rs/app/device/master";
            break;
        case GetGongzuo:
            url = @"/rs/app/device/workStatus";
            break;
        case VerisonInfo:
            url = @"/rs/app/update/check";
             break;
        case GetVerisonInfo:
            url = @"/rs/app/update/info";
             break;
        case AddStation:
            url = @"/rs/app/station/list";
             break;
        case Gettree:
            url = @"/rs/app/organ/tree";
             break;
        case GetInterestList:
            url = @"/rs/app/interest/getList";
            break;
        case AddInterestStation:
            url = @"/rs/app/interest/saveInterest";
            break;
        case DeleteInterestStation:
            url = @"/rs/app/interest/cancelRever";
            break;
        case SearchInterestStation:
            url = @"/rs/app/interest/list";
            break;
            
        default:
            break;
    }
    return url;
}
@end
