//
//  FSJGongxiaoDetail.h
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJGongxiaoDetail : NSObject

/**
 *  @brief 是否链接
 */
@property (nonatomic, copy)NSString *status;
/**
 *  @brief //索引值
 */
@property (nonatomic, copy)NSString *ampIndex;

/**
 *  @brief //功效值
 */
@property (nonatomic, copy)NSString *outputPower;
/**
 *  @brief //功放取样电流索引
 */
@property (nonatomic, copy)NSString *currentIndex;
/**
 *  @brief //功放取样电流值
 */
@property (nonatomic, copy)NSString *value;

/**
 *  @brief //插件类型 1：表示前级 2：表示末级
 */
@property (nonatomic, copy)NSString *type;

/**
 *  @brief //功放驻波比
 */
@property (nonatomic, copy)NSString *vswr;

/**
 *  @brief //功放温度
 */
@property (nonatomic, copy)NSString *temperature;

/**
 *  @brief //功放电流
 */
@property (nonatomic, copy)NSString *current;
/**
 *  @brief //功放插件型号
 */
@property (nonatomic, copy)NSString *modelNum;
/**
 *  @brief //功放插件程序版本号
 */
@property (nonatomic, copy)NSString *softwareVersion;

/**
 *  @brief //取样电流数量
 */
@property (nonatomic, copy)NSString *currentNum;

/**
 *  @brief //功放输出功率
 */
//@property (nonatomic, copy)NSString *outputPower;

/**
 *  @brief //功放输出功率
 */
@property (nonatomic, copy)NSString *outputPowerW;

/**
 *  @brief //反射功率
 */
@property (nonatomic, copy)NSString *reflectPower;

/**
 *  @brief //推动功率
 */
@property (nonatomic, copy)NSString *drivePower;

/**
 *  @brief //功放电压1
 */
@property (nonatomic, copy)NSString *voltage1;

/**
 *  @brief //功放电压2
 */
@property (nonatomic, copy)NSString *voltage2;

/**
 *  @brief //功放AGC电压
 */
@property (nonatomic, copy)NSString *agcVol;

/**
 *  @brief //过激电压
 */
@property (nonatomic, copy)NSString *extreVol;

/**
 *  @brief //风扇转速
 */
@property (nonatomic, copy)NSString *fan;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
