//
//  FSJNetWorking.h
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
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
    
    
};
typedef NS_ENUM(NSInteger, UploadActionType) {
    UserHeaderImageAction = 1 <<4,
};
typedef void(^UploadFormDataBlock) (id<AFMultipartFormData> formData);
@interface FSJNetWorking : AFHTTPRequestOperationManager
+ (AFHTTPRequestOperationManager *)networkingGETWithURL:(NSString *)URL
                                             requestDictionary:(NSDictionary *)requestDictionary
                                                       success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)networkingPOSTWithActionType:(NetworkConnectionActionType)actionType
                                           requestDictionary:(NSDictionary *)requestDictionary
                                                     success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (AFHTTPRequestOperation *)networkingPostIconWithActionType:(NetworkConnectionActionType)actionType
                                       requestDictionary:(NSDictionary *)requestDictionary
                                                 success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (AFHTTPRequestOperationManager *)networkingGETWithActionType:(NetworkConnectionActionType)actionType
                                   requestDictionary:(NSDictionary *)requestDictionary
                                             success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary* responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)uploadDataWithActionType:(NetworkConnectionActionType)actionType
               requestDictionary:(NSDictionary *)requestDictionary
                  uploadFormData:(NSArray *)imageData
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSString *error))failure;

+ (void)requestPoliceDataStoreWithParameters:(NSArray *)parameters
                                  actionType:(NetworkConnectionActionType )actionType
                               progressBlock:(void (^)(
                                                       NSUInteger numberOfFinishedOperations,NSUInteger totalNumberOfOperations))progressBlock
                                  completion:(void (^)(NSArray *results, NSError *error))completion;

@end
