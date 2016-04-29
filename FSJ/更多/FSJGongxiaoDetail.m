//
//  FSJGongxiaoDetail.m
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJGongxiaoDetail.h"

@implementation FSJGongxiaoDetail


+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJGongxiaoDetail *model = [self mj_objectWithKeyValues:dictionary];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
