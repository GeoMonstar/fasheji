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
    /**
     *  @brief Add发射站
     */
    AddStation,
    
    /**
     *  @brief 获取机构
     */
    Gettree,
    
    /**
     *  @brief 获取已经添加的站点列表
     */
    GetInterestList,
    
    /**
     *  @brief 添加收藏站点
     */
    AddInterestStation,
    
    /**
     *  @brief 删除站点列表
     */
    DeleteInterestStation,
    
    /**
     *  @brief 搜索站点列表
     */
    SearchInterestStation,
    /**
     *  @brief 设备结构
     */
    ShebeiJiegou50W,
    /**
     *  @brief 设备信息
     */
    ShebeiInfo50W,
    /**
     *  @brief 通信接口
     */
    TongxinJiekou50W,
    /**
     *  @brief 整机控制
     */
    ZhengjiKongzhi50W,
    /**
     *  @brief 整机状态
     */
    ZhengjiStatus50W,
    /**
     *  @brief 电源
     */
    Dianyuan50W,
    /**
     *  @brief 功放
     */
    GongFang50W,
    /**
     *  @brief 激励器-通用参数
     */
    JiliqiTongyong50W,
    /**
     *  @brief 激励器-轮播
     */
    JiliqiLunbo50W,
    /**
     *  @brief 激励器-输入参数
     */
    JiliqiInput50W,
    /**
     *  @brief 激励器-输出参数
     */
    JiliqiOutput50W,
    /**
     *  @brief 激励器-单频网
     */
    JiliqiDanpin50W,
    /**
     *  @brief 激励器-工作状态
     */
    JiliqiWorkStatus50W,
    /**
     *  @brief 解调
     */
    Jietiao50W,
    /**
     *  @brief 通道
     */
    Tongdao50W,
    /**
     *  @brief DTU不常用参数

     */
    DTUabnormal50W,
    /**
     *  @brief DTU正常用参数

     */
    DTUnormal50W,
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
