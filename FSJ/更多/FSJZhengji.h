//
//  FSJZhengji.h
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJZhengji : NSObject

/**
 *  @brief 发射机功率dBm
 */
@property (nonatomic, copy)NSString *po;
/**
 *  @brief //反射功率
 */
@property (nonatomic, copy)NSString *pr;
/**
 *  @brief 驻波比
 */
@property (nonatomic, copy)NSString *vswr;
/**
 *  @brief 电流
 */
@property (nonatomic, copy)NSString *current;

/**
 *  @brief 温度
 */
@property (nonatomic, copy)NSString *temperature;
/**
 *  @brief Cn
 */
@property (nonatomic, copy)NSString *cn;
/**
 *  @brief 功率W
 */
@property (nonatomic, copy)NSString *poW;
/**
 *  @brief
 */
@property (nonatomic, copy)NSString *unbalacePower;
/**
 *  @brief 电压1
 */
@property (nonatomic, copy)NSString *voltage1;
/**
 *  @brief 电压2
 */
@property (nonatomic, copy)NSString *voltage2;
/**
 *  @brief agc电压
 */
@property (nonatomic, copy)NSString *agcVol;
/**
 *  @brief //过激指示电压
 */
@property (nonatomic, copy)NSString *overloadVol;

/**
 *  @brief A相电流
 */
@property (nonatomic, copy)NSString *currentA;
/**
 *  @brief B相电流
 */
@property (nonatomic, copy)NSString *currentB;
/**
 *  @brief C相电流
 */
@property (nonatomic, copy)NSString *currentC;
/**
 *  @brief A相电压
 */
@property (nonatomic, copy)NSString *voltageA;
/**
 *  @brief B相电压
 */
@property (nonatomic, copy)NSString *voltageB;
/**
 *  @brief C相电压
 */
@property (nonatomic, copy)NSString *voltageC;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
