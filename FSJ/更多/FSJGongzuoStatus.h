//
//  FSJGongzuoStatus.h
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJGongzuoStatus : NSObject

///**
// *  @brief 状态
// */
//@property (nonatomic, copy)NSString *message;
///**
// *  @brief 状态码
// */
//@property (nonatomic, copy)NSString *status;
///**
// *  @brief 返回数据
// */
//@property (nonatomic, copy)NSString *data;
/**
 *  @brief 设备状态
 */
@property (nonatomic, copy)NSString *status;
/**
 *  @brief 温度
 */
@property (nonatomic, copy)NSString *temperature;
/**
 *  @brief 告警开关
 */
@property (nonatomic, copy)NSString *alarmSwitch;
/**
 *  @brief 时间
 */
@property (nonatomic, copy)NSString *nowDate;
/**
 *  @brief 主机：0/备机状态:1
 */
@property (nonatomic, copy)NSString *operateState;
/**
 *  @brief 开机:0/关机状态:1
 */
@property (nonatomic, copy)NSString *onoffState;
/**
 *  @brief 本控:0/遥控状态:1
 */
@property (nonatomic, copy)NSString *romoteState;
/**
 *  @brief  //自动切换主备机
 */
@property (nonatomic, copy)NSString *autoSwitch;
/**
 *  @brief //天线:0/假负载状态:1
 */
@property (nonatomic, copy)NSString *anternaState;
/**
 *  @brief 最近一次复位的原因
 */
@property (nonatomic, copy)NSString *resetCause;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
