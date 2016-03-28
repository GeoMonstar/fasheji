//
//  AppKeys.h
//  UJF
//
//  Created by bing on 15/8/25.
//  Copyright (c) 2015年 JUNN. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @brief  推送
 */
extern NSString *const NotificationCategoryIdent;
extern NSString *const NotificationActionOneIdent;
extern NSString *const NotificationActionTwoIdent;

/**
 *  @brief  请求数据成功(@"000000")
 */
extern NSString *const kNetworkStatusWithSuccess;
/**
 *  @brief  应用第一次运行标识
 */
extern NSString *const kAPPIsFirstLaunch;
/**
 *  @brief  应用程序加载
 */
extern NSString *const kAPPFinishLaunching;
/**
 *  @brief  应用标识
 */
extern NSString *const kAppIdentifierID;
/**
 *  @brief  用户信息
 */
extern NSString *const kAppUserInfo;
/**
    @brief 用户账号
 */
extern NSString *const kAppUserAccount;
/**
 *  @brief  用户ID
 */
extern NSString *const kAPPUserID;
/**
 @brief 用户密钥
 */
extern NSString *const kAppUserPassKey;
/**
 *  @brief  用户位置
 */
extern NSString *const kAppUserLocation;
/**
 *  @brief  客服电话
 */
extern NSString *const kAppServiceCallNum;

#pragma mark-

/**
 @brief 输入手机号码为空
 */
extern NSString *const kEnterNullPhoneNum;
/**
 @brief 输入手机号码有误
 */
extern NSString *const kEnterNotPhoneNum;
/**
  @brief 网络连接失败
 */
extern NSString *const kNetwokWithOutCollection;
/**
    @brief 请输入验证码
 */
extern NSString *const kEnterNullVeriCode;
/**
 *  @brief  请输入密码
 */
extern NSString *const kEnterNullPassword;
/**
    @brief 输入密码有误
 */
extern NSString *const kEnterErrorPassword;
/**
 *  @brief  登录通知
 */
extern NSString *const kNotificationWithLogin;
/**
 *  @brief  登出通知
 */
extern NSString *const kNotificationWithLogout;
/**
 *  @brief  车辆编辑通知
 */
extern NSString *const kNotificationWithEditCar;
/**
 *  @brief  U集星更新通知
 */
extern NSString *const kNotificationWithUScoreValue;
/**
 *  @brief  触发更新U积星
 */
extern NSString *const KNotificationWithTriggerUScoreAction;
/**
 *  @brief  广告位标识
 */
extern NSString *const kAdCode;
/**
 *  @brief  推送跳转
 */
extern NSString* const kNotificationWithPushNoti;
/**
 *  @brief  城市列表更新
 */
extern NSString *const kNotificationUpdateCityList;

/**
 *  @brief  登录成功跳转
 */
extern NSString *const kNotificationLoginSuccessReturn;
/**
 *  @brief  缓存
 */
extern NSString *const kCacheByColumnTree;//栏目树
extern NSString *const kCacheByProductList;//产品列表
extern NSString *const kCacheByColumnTreeVersion;//栏目树版本
extern NSString *const kCacheByMessageFlag;//消息推送标示
extern NSString *const kCacheByLaunchImageView;//启动页广告
extern NSString *const kCacheByLaunchImageTime;//设置广告显示时间

extern NSString *const kNotificationWithWeChatPay;//
extern NSString *const kNotificationWithWeChatPaySuccess;
extern NSString *const kNotificationWithWeChatPayFailed;
extern NSString *const kNotificationWithWeChatPayCancel;

