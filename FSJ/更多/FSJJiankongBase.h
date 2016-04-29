//
//  FSJJiankongBase.h
//  FSJ
//
//  Created by Monstar on 16/4/27.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJJiankongBase : NSObject
/**
 *  @brief 状态
 */
@property (nonatomic, copy)NSString *message;
/**
 *  @brief 状态码
 */
@property (nonatomic, copy)NSString *status;
/**
 *  @brief 返回数据
 */
@property (nonatomic, copy)NSDictionary *data;

/**
 *  @brief电流表
 */
@property (nonatomic, retain)NSArray *table;
/**
 *  @brief
 */
@property (nonatomic, retain)NSArray *main;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
