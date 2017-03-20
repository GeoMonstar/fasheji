//
//  FSJStationInfo.m
//  FSJ
//
//  Created by Monstar on 16/6/7.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJStationInfo.h"

@implementation FSJStationInfo



+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJStationInfo *model = [self mj_objectWithKeyValues:dictionary];
    return model;
}
@end
