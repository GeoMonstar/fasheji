//
//  FSJUserInfo.h
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FSJResultList.h"
#import "FSJCommonModel.h"
typedef NS_ENUM(NSInteger, LoginStatusType) {
    StatusWithLoginOut,//登入
    StatusWithLogin,//登出
};
@interface FSJUserInfo : NSObject

+ (FSJUserInfo *)shareInstance;

#pragma mark -- 登录类
/**
 *  @brief  用户登录状态
 */
@property (nonatomic, assign) LoginStatusType statusType;
/**
 *  @brief  推送频道
 */
@property (nonatomic, copy)NSString *topic;
/**
 *  @brief  告警总量
 */
@property (nonatomic, copy)NSString *alarmTotal;
/**
 *  @brief  用户登录结果
 */
@property (nonatomic, copy)NSString *message;
/**
 *  @brief  用户区域名称
 */
@property (nonatomic, copy)NSString *areaName;
/**
 *  @brief  用户区域等级
 */
@property (nonatomic, copy)NSString *areaType;
/**
 *  @brief  用户状态
 */
@property (nonatomic, copy)NSString *status;
/**
 *  @brief  认证参数
 */
@property (nonatomic, copy)NSString *jwt;
/**
 *  @brief  用户ID
 */
@property (nonatomic, copy)NSString *userId;

/**
 *  @brief  用户所属区域ID
 */
@property (nonatomic, copy)NSString *areaId;
/**
 *  @brief  机构名称
 */
@property (nonatomic, copy)NSString *officeName;
#pragma mark -- 个人信息类
/**
 *  @brief  用户登录状态
 */
//@property (nonatomic, assign)NSString *userId;
/**
 *  @brief  用户名
 */
@property (nonatomic, copy)NSString *loginName;
/**
 *  @brief  用户真实姓名
 */
@property (nonatomic, copy)NSString *name;
/**
 *  @brief  用户工号
 */
@property (nonatomic, copy)NSString *no;
/**
 *  @brief  用户手机号
 */
@property (nonatomic, copy)NSString *mobile;
/**
 *  @brief  用户固机号
 */
@property (nonatomic, copy)NSString *phone;
/**
 *  @brief  用户邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  @brief  归属机构
 */
@property (nonatomic, copy) NSString *company;
/**
 *  @brief  照片
 */
@property (nonatomic, copy) NSString *photo;

#pragma mark -- 管理人员查询
/**
 *  @brief  数据量
 */
@property (nonatomic, copy) NSString *count;
/**
 *  @brief  当前页面
 */
@property (nonatomic, copy) NSString *pageNo;
/**
 *  @brief  页面容量大小
 */
@property (nonatomic, copy) NSString *pageSize;
#pragma mark -- 查询返回列表

@property (nonatomic, retain)NSArray *list;

@property (nonatomic, strong)FSJCommonModel *usermodel;




- (FSJCommonModel *)userAccount;



- (NSString *)userName;

- (NSString *)userID;

- (void)setUserInfomationWithUserName:(NSString *)userName userId:(NSString *)userId;

- (void)deleteUserAccount;

- (BOOL)userAccountStatus;
@end
