//
//  FSJResultList.h
//  FSJ
//
//  Created by Monstar on 16/3/8.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJResultList : NSObject
/**
 *  @brief 所属区域
 */
@property (nonatomic, copy)NSString *areaName;
/**
 *  @brief 台站警告数目
 */
@property (nonatomic, copy)NSString *alarmSize;
/**
 *  @brief  区域ID
 */
@property (nonatomic, copy)NSString *areaId;
/**
 *  @brief  区域ID
 */
@property (nonatomic, copy)NSString *ID;
/**
 *  @brief  "0,1,",
 */
@property (nonatomic, copy)NSString *parentIds;
/**
 *  @brief  省份名字
 */
@property (nonatomic, copy)NSString *name;
/**
 *  @brief  经度
 */
@property (nonatomic, copy)NSString *lon;
/**
 *  @brief  纬度
 */
@property (nonatomic, copy)NSString *lat;
/**
 *  @brief  是否告警 0-无告警  1-有告警
 */
@property (nonatomic, copy)NSString *status;
/**
 *  @brief  发射站总数量
 */
@property (nonatomic, copy)NSString *alarmTotal;
/**
 *  @brief  区域等级
 */
@property (nonatomic, copy)NSString *areaType;
/**
 *  @brief  地址信息
 */
@property (nonatomic, copy)NSString *address;
#pragma mark -- 告警信息列表
/**
 *  @brief  警告时间
 */
@property (nonatomic, copy)NSString *time;
/**
 *  @brief  地址信息
 */
@property (nonatomic, copy)NSString *value;
#pragma mark -- 所有发射机
/**
 *  @brief  ip地址
 */
@property (nonatomic, copy)NSString *ipaddr;
/**
 *  @brief  反射功率
 */
@property (nonatomic, copy)NSString *masterPr;
/**
 *  @brief  入射功率
 */
@property (nonatomic, copy)NSString *masterPo;

#pragma mark -- 查看某个发射机的详细信息
/**
 *  @brief  状态
 */
@property (nonatomic, copy)NSString *state;
/**
 *  @brief  端口号
 */
@property (nonatomic, copy)NSString *port;
/**
 *  @brief  安装地址
 */
@property (nonatomic, copy)NSString *location;
/**
 *  @brief  通讯模式
 */
@property (nonatomic, copy)NSString *commmode;
/**
 *  @brief  功率等级
 */
@property (nonatomic, copy)NSString *powerRate;
/**
 *  @brief  发射站名称
 */
@property (nonatomic, copy)NSString *sname;
/**
 *  @brief  发射机类型
 */
@property (nonatomic, copy)NSString *type;
/**
 *  @brief  查询返回结果
 */
@property (nonatomic, copy)NSString *message;
/**
 *  @brief  射频机类型
 */
@property (nonatomic, copy)NSString *rfdelay;
/**
 *  @brief  工作模式
 */
@property (nonatomic, copy)NSString *workmode;
/**
 *  @brief  负责人
 */
@property (nonatomic, copy)NSString *manager;
/**
 *  @brief  发射机名称
 */
@property (nonatomic, copy)NSString *tname;
#pragma mark -- 查看某个管理员
/**
 *  @brief  职务
 */
@property (nonatomic, copy)NSString *position;
/**
 *  @brief  手机号
 */
@property (nonatomic, copy)NSString *phone;
/**
 *  @brief  性别
 */
@property (nonatomic, copy)NSString *gender;
/**
 *  @brief  管理人员的ID
 */
@property (nonatomic, copy)NSString *managerId;
#pragma mark -- 警告详情
/**
 *  @brief  告警信息ID
 */
@property (nonatomic, copy)NSString *alarmId;
/**
 *  @brief  等级
 */
@property (nonatomic, copy)NSString *level;
/**
 *  @brief  设备类型
 */
@property (nonatomic, copy)NSString *deviceType;
/**
 *  @brief  描述
 */
@property (nonatomic, copy)NSString *descript;
/**
 *  @brief  模块类型
 */
@property (nonatomic, copy)NSString *moduleType;
/**
 *  @brief  告警时间
 */
@property (nonatomic, copy)NSString *timestamp;
/**
 *  @brief  恢复时间
 */
@property (nonatomic, copy)NSString *timerecover;
#pragma mark -- 发射站详情
/**
 *  @brief  所属机构
 */

@property (nonatomic, copy)NSString *stationId;
/**
 *  @brief  所属机构
 */
@property (nonatomic, copy)NSString *organName;

/**
 *  @brief 编号
 */
@property (nonatomic, copy)NSString *no;


/**
 *  @brief 海拔
 */
@property (nonatomic, copy)NSString *altitude;
/**
 *  @brief 固定电话
 */
@property (nonatomic, copy)NSString *mobile;
#pragma mark -- 发射机详情

/**
 *  @brief 发射机id
 */
@property (nonatomic, copy)NSString *transId;
/**
 *  @brief ip 地址
 */
@property (nonatomic, copy)NSString *ipAddr;
/**
 *  @brief 通讯模式
 */
@property (nonatomic, copy)NSString *commMode;
/**
 *  @brief 工作模式
 */
@property (nonatomic, copy)NSString *workMode;
/**
 *  @brief 序列号
 */
@property (nonatomic, copy)NSString *seriesNo;
/**
 *  @brief 发射机类型
 */
@property (nonatomic, copy)NSString *transmitterType;
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
