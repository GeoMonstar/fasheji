//
//  Request.h
//  test
//
//  Created by RIMIMAX on 14-7-11.
//  Copyright (c) 2014年 FuQingshan. All rights reserved.
//

typedef void(^RequestSuccess)(id requestSuccess);
typedef void(^RequestError)(id requestError);
typedef void(^RequestProgress)(id requestProgress);

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
//#import "NSString+GettimeNowSSS.h"

@interface Request : NSObject

typedef enum{
UploadPNGFile,//PNG
UploadJPEGFile,//JPEG
UploadVIDEOFile,//视频
}UploadFileMimeType;

/**
 *  Post请求 上传流文件
 *
 *  @param url          整个请求的url
 *  @param paremeter     参数，字典形式
 *  @param fileData        上传文件二进制
 *  @param fileKey          上传文件服务器对应的Key
 *  @param fileName      上传文件名字
 *  @param finishedTure  成功返回id
 *  @param finishedFalse 失败返回错误描述字符串
 */
+ (void)sendPostBlockWithParemeterAndRequestURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter FileData:(NSData *)fileData FileKey:(NSString *)fileKey FileName:(NSString *)fileName UploadFileMimeType:(UploadFileMimeType )uploadFileMimeType RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse;

/**
 *  Post请求 文件路径上传
 *
 *  @param url          整个请求的url
 *  @param paremeter     参数，字典形式
 *  @param filePath        上传文件路径
 *  @param fileName      上传文件名字
 *  @param finishedTure  成功返回id
 *  @param finishedFalse 失败返回错误描述字符串
 */
+ (void)sendPostBlockWithParemeterAndRequestURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter FilePath:(NSString *)filePath FileName:(NSString *)fileName RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse;
/**
 *  Post请求
 *
 *  @param url          整个请求的url
 *  @param paremeter     参数，字典形式
 *  @param finishedTure  成功返回id
 *  @param finishedFalse 失败返回错误描述字符串
 */
+ (void)sendPostBlockWithParemeterAndRequestURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse;

/**
 *  Get请求
 *
 *  @param url          请求的url
 *  @param paremeter    参数,字典形式（自动转成get拼接）
 *  @param finishedTure  成功返回id
 *  @param finishedFalse 失败返回错误描述字符串
 */
+ (void)sendGetWithURL:(NSURL *)url Paremeter:(NSDictionary *)paremeter RequestProgress:(RequestProgress)finishProgress RequestSuccess:(RequestSuccess)finishedTure RequestError:(RequestError)finishedFalse;

/**
 *  把字典转化成json字符串
 *
 *  @param obj 数据字典
 *
 *  @return json字符串
 */
+ (NSString *)sendDictionaryReturnJsonString:(id )obj;
/**
 *  把字典转成get请求的拼接参数部分
 *
 *  @param dic 请求参数
 *
 *  @return get请求拼接好的参数(例如:?token=1000&versionId=21)
 */
+(NSString *)sendDictionalryReturnGetString:(NSDictionary *)dic;

/**
 *  取消所有网络请求
 */
+ (void)cancleAllRequest;

@end
