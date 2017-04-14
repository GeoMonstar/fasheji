//
//  FSJNetworking.m
//  FSJ
//
//  Created by Monstar on 16/5/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJNetworking.h"
#import "FSJLogInViewController.h"
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
    
    AFHTTPSessionManager *manager = [self getManager];
    
    [manager GET:getURL parameters:requestDictionary progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //failure(task,error);
        NSArray *array = error.userInfo.allValues;
        id response = array[0];
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            //登录冲突
            if ([[response valueForKey:@"statusCode"]integerValue] == 401) {
                [MBProgressHUD showError:kAccountChanged];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationWithLogout object:nil userInfo:nil];
                    
                });
            }
        }else{
            [MBProgressHUD showError:@"网络异常"];
        }
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

    
    AFHTTPSessionManager *manager = [self getManager];
    [manager GET:URL parameters:requestDictionary progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        
//        NSDictionary *datadic = [responseObject objectForKey:@"data"];
//        if (datadic!= nil && datadic.allKeys.count ==0) {
//            [MBProgressHUD showError:@"数据为空"];
//            return;
//        }
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //failure(task,error);
        //登出
        
        NSArray *array = error.userInfo.allValues;
        id response = array[0];
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            if ([[response valueForKey:@"statusCode"]integerValue] == 401) {
                [MBProgressHUD showError:kAccountChanged];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationWithLogout object:nil userInfo:nil];
                });
            }
        }else{
           [MBProgressHUD showError:@"网络异常"];
        }
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

    AFHTTPSessionManager *manager = [self getManager];
    [manager POST:URL parameters:requestDictionary progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {

        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(task,error);
    }];
    return manager;
}
+ (AFHTTPSessionManager *)getManager{

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];//如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//   manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明返回的结果是json类型
//   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];//如果报接受类型不一致请替换一致text/html或别的
//   manager.requestSerializer=[AFHTTPRequestSerializer serializer];//申明请求的数据是json类型
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
            url = @"/rs/app/map/station/transmitter/getById";
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
        case ShebeiInfo50W:
            url = @"/rs/app/device/tcpip/info";
            break;
        case TongxinJiekou50W:
            url = @"/rs/app/device/tcpip/communicate";
            break;
        case ZhengjiKongzhi50W:
            url = @"/rs/app/device/tcpip/stateControl";
            break;
        case ZhengjiStatus50W:
            url = @"/rs/app/device/tcpip/state";
            break;
        case Dianyuan50W:
            url = @"/rs/app/device/tcpip/power";
            break;
        case GongFang50W:
            url = @"/rs/app/device/tcpip/amp";
            break;
        case JiliqiTongyong50W:
            url = @"/rs/app/device/tcpip/actuator";
            break;
        case JiliqiLunbo50W:
            url = @"/rs/app/device/tcpip/statusMult";
            break;
        case JiliqiInput50W:
            url = @"/rs/app/device/tcpip/inputParam";
            break;
        case JiliqiOutput50W:
            url = @"/rs/app/device/tcpip/outputParam";
            break;
        case JiliqiDanpin50W:
            url = @"/rs/app/device/tcpip/single";
            break;
        case JiliqiWorkStatus50W:
            url = @"/rs/app/device/tcpip/status";
            break;
        case Jietiao50W:
            url = @"/rs/app/device/tcpip/inputrf";
            break;
        case Tongdao50W:
            url = @"/rs/app/device/tcpip/pipe";
            break;
        case DTUabnormal50W:
            url = @"/rs/app/device/tcpip/dtuunusual";
            break;
        case DTUnormal50W:
            url = @"/rs/app/device/tcpip/dtuusual";
            break;
        default:
            break;

    }
    return url;
}
@end
