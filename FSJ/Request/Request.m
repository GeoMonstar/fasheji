//
//  Request.m
//  test
//
//  Created by RIMIMAX on 14-7-11.
//  Copyright (c) 2014年 FuQingshan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Request.h"

#import"AFNetworking.h"
#import "SCHTTPSessionManager.h"

@implementation Request

#pragma mark - postBlock请求

+ (void)sendPostBlockWithParemeterAndRequestURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter  FileData:(NSData *)fileData FileKey:(NSString *)fileKey FileName:(NSString *)fileName UploadFileMimeType:(UploadFileMimeType )uploadFileMimeType RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse;
{
    NSString * mimeType = @"";
    switch (uploadFileMimeType) {
        case UploadPNGFile:
        {
            mimeType = @"image/png";
            NSString * temp = @".png";
            NSRange  range = [fileName rangeOfString:temp];
            if (!(range.length>0)) {
                fileName = [NSString stringWithFormat:@"%@.png",fileName];

            }
            
        }
            break;
        case UploadJPEGFile:
        {
            mimeType = @"image/jpeg";
           
            if (!(([fileName rangeOfString:@".jpg"].length>0) || ([fileName rangeOfString:@".jpeg"].length>0))) {
                fileName = [NSString stringWithFormat:@"%@.jpg",fileName];
            }
            
        }
            break;
          case UploadVIDEOFile:
        {
            mimeType = @"video/quicktime";
            NSString * temp = @".mov";
            NSRange  range = [fileName rangeOfString:temp];
            if (!(range.length>0)) {
                fileName = [NSString stringWithFormat:@"%@.mov",fileName];
            }
         
        }
            break;
        default:
            
            break;
    }
    
    
    SCHTTPSessionManager *manager = [self initializationSessionManager];
//    if (manager.isSecrecy) {
//        paremeter = [AESDataValue sendJsonDataToAESData:[paremeter copy]];
//    }
    
    [manager POST:url.absoluteString parameters:paremeter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if ([fileName isEqualToString:@""] || fileName == nil) {
            
            [formData appendPartWithFileData:fileData name:fileKey fileName:[NSString stringWithFormat:@"%@",[self getTimeNow]] mimeType:mimeType];

        }
        else
        {
            
            [formData appendPartWithFileData:fileData name:fileKey fileName:fileName mimeType:mimeType];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        finishProgress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [self serializatioJsonDataWithManager:manager Task:task Data:responseObject RequestSuccess:finishedTure RequestError:finishedFalse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self RequestWithFaile:error RequestError:finishedFalse];

    }];

}

+ (void)sendPostBlockWithParemeterAndRequestURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter FilePath:(NSString *)filePath FileName:(NSString *)fileName RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse
{
    
    SCHTTPSessionManager *manager = [self initializationSessionManager];
    if (manager.isSecrecy) {
        //paremeter = [AESDataValue sendJsonDataToAESData:[paremeter copy]];
    }
    [manager POST:url.absoluteString parameters:paremeter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
                NSURL * filePathURL = [NSURL fileURLWithPath:filePath];
                NSError * error = nil;
                if ([fileName isEqualToString:@""] || fileName == nil) {
                    
                    [formData appendPartWithFileURL:filePathURL name:[NSString stringWithFormat:@"%@",[Request getTimeNow]] error:&error];
                    
                }
                else
                {
                    
                    [formData appendPartWithFileURL:filePathURL name:[NSString stringWithFormat:@"%@",fileName] error:&error];
                }
            
                if (!(error == nil)) {
                    VVDLog(@"\n😭_😭：上传文件出错！%@",error);
                }
                
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            finishProgress(uploadProgress);
        
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            [self serializatioJsonDataWithManager:manager Task:task Data:responseObject RequestSuccess:finishedTure RequestError:finishedFalse];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self RequestWithFaile:error RequestError:finishedFalse];

            }];
}

+ (void)sendPostBlockWithParemeterAndRequestURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse;
{
    SCHTTPSessionManager *manager = [self initializationSessionManager];
    
//    if (manager.isSecrecy) {
//        paremeter = [AESDataValue sendJsonDataToAESData:[paremeter copy]];
//    }
    
    [manager POST:url.absoluteString parameters:paremeter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
//    [self serializatioJsonDataWithManager:manager Task:task Data:responseObject RequestSuccess:finishedTure RequestError:finishedFalse];
         finishedTure(responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self RequestWithFaile:error RequestError:finishedFalse];
    }];
}
#pragma mark - get请求
+ (void)sendGetWithURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse
{
    
    SCHTTPSessionManager *manager = [self initializationSessionManager];
   
    
//    if (manager.isSecrecy) {
//        paremeter = [AESDataValue sendJsonDataToAESData:[paremeter copy]];
//    }
    [manager GET:url.absoluteString parameters:paremeter progress:^(NSProgress * _Nonnull downloadProgress) {
        finishProgress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedTure(responseObject);
//        [self serializatioJsonDataWithManager:manager Task:task Data:responseObject       RequestSuccess:finishedTure RequestError:finishedFalse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //登出
        NSArray *array = error.userInfo.allValues;
        id response = array[0];
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            if ([[response valueForKey:@"statusCode"]integerValue] == 401) {
                [MBProgressHUD showMessage:AccountBalance];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationWithLogout object:nil userInfo:nil];
                    [MBProgressHUD hideHUD];
                });
            }
        
        }else{
            [MBProgressHUD showError:@"服务器维护中"];
            [self RequestWithFaile:error RequestError:finishedFalse];
        }
    }];
}

#pragma mark - 序列化Json数据
+ (void)serializatioJsonDataWithManager:(SCHTTPSessionManager *)manager Task:(NSURLSessionDataTask * _Nullable)task Data:(id  _Nullable)responseObject RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse
{
    
    if (responseObject == nil) {
        VVDLog(@"\n😭_😭：data不能为空指针");
        dispatch_async(dispatch_get_main_queue(), ^{
            finishedFalse(@"服务器异常，请求数据有误！");
        });
        
    }
    else{
        
        NSError * error = nil;
        NSString * withNullString = @"";
        if (manager.isSecrecy) {
            //返回回来的为AES16进制
            NSString * dataToHexString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            //NSString * normalJsonString = [AESDataValue sendAESHexJsonDataToJsonStr:dataToHexString];
            withNullString =dataToHexString;
        }
        else
        {
            withNullString = [self sendDictionaryReturnJsonString:responseObject];
        }
 
        NSString * noNullString = [withNullString stringByReplacingOccurrencesOfString:@"""null""" withString:@""];
        noNullString = [withNullString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
        NSData * noNullData = [noNullString dataUsingEncoding:NSUTF8StringEncoding];
        responseObject = [NSJSONSerialization JSONObjectWithData:noNullData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            VVDLog(@"\n😭_😭：%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedFalse(@"解析数据失败！");
            });
        }
        else
        {
            //VVDLog(@"\n😊_😊正确数据：%@",responseObject);
            [[NSUserDefaults standardUserDefaults]setObject:((NSHTTPURLResponse *)task.response).allHeaderFields[@"Set-Cookie"] forKey:@"CheckNumCookie"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedTure(responseObject);
            });
        }
    }
}

#pragma mark - 请求出错的处理
+ (void)RequestWithFaile:(NSError * _Nonnull )error RequestError:(RequestError)finishedFalse{
    
        if (!(error == nil)) {
        VVDLog(@"\n😭_😭：错误！%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            finishedFalse(@"服务器异常，请求数据失败！");
        });
    }
}

#pragma mark - 初始化AFHTTPSessionManager
+ (SCHTTPSessionManager *)initializationSessionManager
{
    SCHTTPSessionManager *manager = [SCHTTPSessionManager shareInstance];
    //是否需要加密
    //manager.isSecrecy = YES;
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",[[[NSUserDefaults standardUserDefaults] objectForKey:@"netWorkState"] integerValue]]
//                                   forHTTPHeaderField:@"netWorkState"];
//    [manager.requestSerializer setValue:[NSString getTimeNow] forHTTPHeaderField:@"timestamp"];
//    [manager.requestSerializer setValue:[SSKeychain accessToken] forHTTPHeaderField:@"token"];
//    
//    manager.requestSerializer.timeoutInterval = 5;
//    NSString * cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"CheckNumCookie"];
//    if (cookie != nil) {
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",cookie]forHTTPHeaderField:@"Cookie"];
//    }
    return manager;
}

#pragma mark - 取消网络请求
+ (void)cancleAllRequest
{
    SCHTTPSessionManager *manager = [self initializationSessionManager];
    [manager.operationQueue cancelAllOperations];
}


#pragma mark - 把字典转成Get拼接
+(NSString *)sendDictionalryReturnGetString:(NSDictionary *)dic
{
    NSString * getString = @"";
    for (int i = 0; i<[[dic allKeys] count]; i++) {
        if (i != 0) {
            getString = [getString stringByAppendingString:@"&"];
        }
        
        NSString * appending = [NSString stringWithFormat:@"%@=%@",[[dic allKeys] objectAtIndex:i],[dic objectForKey:[[dic allKeys] objectAtIndex:i]]];
        getString = [getString stringByAppendingString:appending];
    }
    
    return getString;
}


#pragma mark - 把字典转化成json数据
+ (NSString *)sendDictionaryReturnJsonString:(id )obj;
{
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    VVDLog(@"\n转换json字符串error：\n%@",error);
    return jsonString;
}

#pragma mark - 返回当前时间精确到秒作为图片名
+ (NSString *)getTimeNow
{
    
    NSString * date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];//秒
    //        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];//毫秒
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    NSString * ss= timeNow;
    for(int i = 0;i<timeNow.length;i++)
    {
        unichar s = [timeNow characterAtIndex:i];
        if (s >= '0' && s <= '9') {
            
        }
        else
        {
            ss =  [ss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",s] withString:@""];
        }
    }
    return ss;
}


@end
