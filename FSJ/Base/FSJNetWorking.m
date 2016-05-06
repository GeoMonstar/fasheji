//
//  FSJNetWorking.m
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJNetWorking.h"
#import <CommonCrypto/CommonCrypto.h>
#import "FSJDES.h"

//接口URL统一为：平台ip地址:端口/fsj/rs/app/+接口名



#define TimeoutInterval 15
#define CallType @"4"
#define PageSize @"14"
#define Action_XX @"fsjFM"
@interface FSJNetWorking()
@end

@implementation FSJNetWorking
+ (AFHTTPRequestOperationManager *)networkingGETWithURL:(NSString *)URL
                                             requestDictionary:(NSDictionary *)requestDictionary
                                                       success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSString  *getURL =[NSString stringWithFormat:@"%@%@",BaseURL,URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:getURL parameters:requestDictionary success:^(AFHTTPRequestOperation *  operation, id   responseObject) {
        NSDictionary *responseDict;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }else{
            responseDict = responseObject;
        }
        success(operation,responseDict);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    return manager;
}
#pragma mark -- GET
+ (AFHTTPRequestOperationManager *)networkingGETWithActionType:(NetworkConnectionActionType)actionType
                                      requestDictionary:(NSDictionary *)requestDictionary
                                                success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSString  *URL =[NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:URL parameters:requestDictionary success:^(AFHTTPRequestOperation *  operation, id   responseObject) {
        NSLog(@"请求参数字典 == %@  url == %@",requestDictionary,URL);
        NSDictionary *responseDict;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }else{
            responseDict = responseObject;
        }
            success(operation,responseDict);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
            return manager;
    }


#pragma mark --POST
+ (AFHTTPRequestOperation *)networkingPOSTWithActionType:(NetworkConnectionActionType)actionType
                                   requestDictionary:(NSDictionary *)requestDictionary
                                             success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeoutInterval];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
   // NSLog(@"body = %@ url = %@",jsonData,URL);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:
     request
                                     success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *responseDict ;
         //返回成功数据
         //NSLog(@"返回数据%@ :%@",actionDict,operation.responseString);
         if ([operation.responseString isEqualToString:@"{}"]||[operation.responseString isEqualToString:@""]||operation.responseString == nil||responseObject == nil) {
             failure(operation,nil);
             return ;
         }
         
         if ([responseObject isKindOfClass:[NSData class]]) {
             responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
         }else{
             responseDict = responseObject;
         }
         success(operation,responseDict);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //返回错误信息
         NSLog(@"返回错误数据:%@",error);
         failure(operation,error);
     }];
    
    [manager.operationQueue addOperation:operation];
    return operation;
}
#pragma mark --图片上传
+ (AFHTTPRequestOperationManager *)networkingPostIconWithActionType:(NetworkConnectionActionType)actionType
                                       requestDictionary:(NSDictionary *)requestDictionary
                                                 success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
    }
    else{
        NSLog(@"JSON字符串转换失败:%@ ,error: %@",requestDictionary,error);
    }
     NSString  *URL =[NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeoutInterval];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:jsonData];
//    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    // NSLog(@"body = %@ url = %@",jsonData,URL);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:URL parameters:jsonData success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDict;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }else{
            responseDict = responseObject;
        }
        success(operation,responseDict);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    return manager;
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
        default:
            break;
    }
    return url;
}
#pragma mark --上传
+ (void)uploadDataWithActionType:(NetworkConnectionActionType)actionType
               requestDictionary:(NSDictionary *)requestDictionary
                  uploadFormData:(NSArray *)imageData
                         success:(void (^)(id))success
                         failure:(void (^)(NSString *))failure{
    NSLog(@"UpLoad Request Dictionary:%@",requestDictionary);
    //1
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"text/json",@"application/json",@"text/javascript",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString  *URL =[NSString stringWithFormat:@"%@%@",BaseURL,[self actionWithConnectionActionType:actionType]];
    [manager POST:URL parameters:requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //多图上传
        for (NSInteger i = 0; i < imageData.count; i++) {
            [formData appendPartWithFileData:imageData[i] name:@"files" fileName:[NSString stringWithFormat:@"image_%ld.jpg",(long)i] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"Success:%@",operation.responseString);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        if (error) {
            failure(error.description);
        }
        NSLog(@"Error:%@",error);
    }];
}
#pragma mark --队列请求
+ (void)requestPoliceDataStoreWithParameters:(NSArray *)parameters
                                  actionType:(NetworkConnectionActionType )actionType
                               progressBlock:(void (^)(
                                                       NSUInteger numberOfFinishedOperations,NSUInteger totalNumberOfOperations))progressBlock
                                  completion:(void (^)(NSArray *results, NSError *error))completion
{
    NSMutableArray *operations = [NSMutableArray new];
    for (NSDictionary *requestDictionary in parameters) {
        //1
        NSDictionary *actionDict = @{@"action":[self actionWithConnectionActionType:actionType],@"digest":[self digestWithConnectionActionType:actionType]};
        //1.1
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:requestDictionary];
        //1.1.1增加终端验证
        [tempDict addEntriesFromDictionary:@{@"callType":CallType}];
        //1.2生成请求字典 没有翻页控制
        NSDictionary *requestDict = @{@"head":actionDict,@"body":tempDict};
        NSLog(@"RequestString = %@",requestDict);
        
        //2.转换JSON字符串
        NSError *error = nil;
        NSString *jsonString = @"";
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData) {
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"JSON字符串转换失败:%@, error: %@",requestDict,error);
        }
        //3.DES加密
        NSString *bodyContent = [FSJDES encrypt:jsonString];
        NSData *body = [bodyContent dataUsingEncoding:NSUTF8StringEncoding];
        //4
        NSURL *URL = [NSURL URLWithString:BaseURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeoutInterval];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:body];
        [request setValue:@"applcation/json" forHTTPHeaderField:@"Content-Type"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        if (operations.count) {
            [operation addDependency:[operations lastObject]];
        }
        [operations addObject:operation];
    }
        NSArray *op = [AFURLConnectionOperation batchOfRequestOperations:operations progressBlock:progressBlock completionBlock:^(NSArray * _Nonnull operations) {
            NSMutableArray *results = [NSMutableArray new];
            
            for (AFHTTPRequestOperation *operation in operations) {
                
                if (operation.error) {
                    if (completion)
                        completion(nil, operation.error);
                    
                    return;
                }
                
                if (operation.responseData) {
                    
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                    
                    [results addObject:result];
                }
            }
            
            if (completion)
                completion([results copy], nil);
            
        }];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue addOperations:op waitUntilFinished:NO];
}
#pragma mark -- get 接口加密
+ (NSString *)digestWithConnectionActionType:(NetworkConnectionActionType)actionType{
    NSString *string = [self actionWithConnectionActionType:actionType];
    if (string == nil || [string isEqualToString:@""]) {
        return @"";
    }
    return [self md5:string];
}
#pragma mark -- post 接口加密
+ (NSString *)digestWithUploadActionType:(UploadActionType)actionType{
    NSString *string = [self actionWithUploadActionType:actionType];
    if (string == nil || [string isEqualToString:@""]) {
        return @"";
    }
    return [self md5:string];
}
+ (NSString *)actionWithUploadActionType:(UploadActionType)actionType{
    NSString *digest = @"";
    switch (actionType) {
        case UserHeaderImageAction://上次头像
            digest = @"xxxxxx";
            break;
        default:
            break;
    }
    return digest;
}
#pragma mark-MD5
+ (NSString *)md5:(NSString *)input{
    NSString *str = [NSString stringWithFormat:@"%@%@",input,Action_XX];//添加必要字段
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (int i = 0 ; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}
@end
