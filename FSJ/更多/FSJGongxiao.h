//
//  FSJGongxiao.h
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJGongxiao : NSObject
/**
 *  @brief 信息
 */
@property (nonatomic, retain)NSString *message;
/**
 *  @brief 状态
 */
@property (nonatomic, retain)NSString *status;
/**
 *  @brief 功率放大单元
 */
@property (nonatomic, retain)NSArray *cnu;

/**
 *  @brief 前置放大单元
 */
@property (nonatomic, retain)NSArray *clts;
/**
 *  @brief table
 */
@property (nonatomic, retain)NSArray *table;

/**
 *  @brief main
 */
@property (nonatomic, copy)NSDictionary *main;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
