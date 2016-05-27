//
//  FSJNetworking.h
//  FSJ
//
//  Created by Monstar on 16/5/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSInteger, NetworkConnectionActionType){
    /**
     *  @brief  登录 POST
     */
    LoginAction,
    /**
     *  @brief  个人资料查看
     */
    UserInfoPreview,
    /**
     *  @brief  个人资料修改 POST
     */
    UserInfoChange,
    /**
     *  @brief  个人密码修改 POST
     */
    UserPwdChange,
    /**
     *  @brief  个人头像上传 POST
     */
    UserIconUpload,
    /**
     *  @brief  退出当前用户
     */
    UserLogoutAction,
    /**
     *  @brief  显示全国发射机告警情况
     */
    NationalarmStatus,
    /**
     *  @brief  显示某个区域发射站告警情况
     */
    AreaalarmStatus,
    /**
     *  @brief  查看发射站下面所有发射机GET
     */
    Allstationquery,
    /**
     *  @brief  查看某个发射机的详细信GET
     */
    Onestationquery,
    /**
     *  @brief  关键字查询GET
     */
    Keywordsquery,
    /**
     *  @brief 显示发射站管理人员信息列表GET
     */
    GetAllManager,
    /**
     *  @brief 查看某个管理人员的具体信息
     */
    GetOneManager,
    /**
     *  @brief 功效信息
     */
    GetGongxiao,
    /**
     *  @brief 功效详情信息
     */
    GetGongxiaoDetail,
    /**
     *  @brief 整机信息
     */
    GetZhengji,
    /**
     *  @brief 工作状态
     */
    GetGongzuo,
    /**
     *  @brief 更新
     */
    VerisonInfo,
    /**
     *  @brief 版本信息
     */
    GetVerisonInfo,
    
};
typedef NS_ENUM(NSInteger, UploadActionType) {
    UserHeaderImageAction = 1 <<4,
};
typedef void(^UploadFormDataBlock) (id<AFMultipartFormData> formData);
@interface FSJNetworking : AFHTTPSessionManager
+(AFHTTPSessionManager *)networkingGETWithURL:(NSString *)URL
                            requestDictionary:(NSDictionary *)requestDictionary
                                      success:(void (^)(NSURLSessionDataTask *operation, NSDictionary* responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask * operation, NSError *error))failure;
+ (AFHTTPSessionManager *)networkingGETWithActionType:(NetworkConnectionActionType)actionType
                                    requestDictionary:(NSDictionary *)requestDictionary
                                              success:(void (^)(NSURLSessionDataTask *operation, NSDictionary* responseObject))success
                                              failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
+ (AFHTTPSessionManager *)networkingPOSTWithActionType:(NetworkConnectionActionType)actionType
                                     requestDictionary:(NSDictionary *)requestDictionary
                                               success:(void (^)(NSURLSessionDataTask *operation, NSDictionary* responseObject))success
                                               failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
+ (AFHTTPSessionManager *)networkingPostIconWithActionType:(NetworkConnectionActionType)actionType
                                         requestDictionary:(NSDictionary *)requestDictionary
                                                  formdata:(void (^)(id<AFMultipartFormData>formData))data
                                                   success:(void (^)(NSURLSessionDataTask *operation,NSDictionary* responseObject))success
                                                   failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

@end
