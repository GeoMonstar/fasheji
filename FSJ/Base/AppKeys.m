//
//  AppKeys.m
//  UJF
//
//  Created by bing on 15/8/25.
//  Copyright (c) 2015年 JUNN. All rights reserved.
//

#import "AppKeys.h"

//推送相关
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

//请求数据成功
NSString *const kNetworkStatusWithSuccess = @"000000";
NSString *const kAPPIsFirstLaunch = @"APPIsFirstLaunch";
NSString *const kAPPFinishLaunching = @"APPFinishLaunching";
NSString *const kAppIdentifierID = @"cn.iyooc.www";
NSString *const kAppUserInfo = @"UserInfo";
NSString *const kAppUserAccount = @"UserAccount";
NSString *const kAPPUserID = @"UserID";
NSString *const kAppUserPassKey = @"UserPassKey";
NSString *const kAppUserLocation = @"UserLocation";
//客服电话
NSString *const kAppServiceCallNum = @"400-032-3166";
//输入手机号码为空
NSString *const kEnterNullPhoneNum = @"请输入账号";
//输入手机号码有误
NSString *const kEnterNotPhoneNum = @"输入的账号码有误";
//网络连接失败
NSString *const kNetwokWithOutCollection = @"网络连接失败";
//请输入验证码
NSString *const kEnterNullVeriCode = @"请输入验证码";
//请输入密码
NSString *const kEnterNullPassword = @"请输入密码";
//输入密码有误
NSString *const kEnterErrorPassword = @"输入密码有误";

/**************NOTIFICATION***********/
//登录通知
NSString *const kNotificationWithLogin = @"NotificationWithLogin";
//登出通知
NSString *const kNotificationWithLogout = @"NotificationWithLogout";
//车辆编辑通知
NSString *const kNotificationWithEditCar = @"NotificationWithEditCar";
//U积星通知
NSString *const kNotificationWithUScoreValue = @"kNotificationWithUScoreValue";
//通知请求U积星
NSString *const KNotificationWithTriggerUScoreAction = @"KNotificationWithTriggerUScoreAction";
//Ad广告
NSString *const kAdCode = @"E969CC31CC2F45118A205648D2DBD599";
//接收通知
NSString *const kNotificationWithPushNoti = @"kNotificationPushMessage";
//城市列表更新通知
NSString *const kNotificationUpdateCityList = @"kNotificationUpdateCityList";
//注册登录跳转通知
NSString *const kNotificationLoginSuccessReturn = @"kNotificationLoginSuccessReturn";
/**************Cache**************/
NSString *const kCacheByColumnTree = @"kCacheByColumnTree";
NSString *const kCacheByProductList = @"kCacheByProductList";
NSString *const kCacheByColumnTreeVersion = @"kCacheByColumnTreeVersion";
NSString *const kCacheByMessageFlag = @"kCacheByMessageFlag";
NSString *const kCacheByLaunchImageView = @"kCacheByLaunchImageView";
NSString *const kCacheByLaunchImageTime = @"kCacheByLaunchImageTime";

//
NSString *const kNotificationWithWeChatPay = @"kNotificationWithWeChatPay";//
NSString *const kNotificationWithWeChatPaySuccess = @"kNotificationWithWeChatPaySuccess";
NSString *const kNotificationWithWeChatPayFailed = @"kNotificationWithWeChatPayFailed";
NSString *const kNotificationWithWeChatPayCancel = @"kNotificationWithWeChatPayCancel";
