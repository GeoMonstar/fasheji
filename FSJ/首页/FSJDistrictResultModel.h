//
//  FSJDistrictResultModel.h
//  FSJ
//
//  Created by Monstar on 2017/1/5.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJBaseModel.h"

@interface FSJDistrictResultModel : FSJBaseModel


/// 行政区域编码
@property (nonatomic, assign) NSInteger code;
/// 行政区域名称
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) float latitude;

@property (nonatomic, assign) float longitude;
/// 行政区边界直角地理坐标点数据(NSString数组，字符串数据格式为: @"x,y;x,y")
@property (nonatomic, strong) NSArray *paths;


@end
