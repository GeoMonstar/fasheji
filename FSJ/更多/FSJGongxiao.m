//
//  FSJGongxiao.m
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJGongxiao.h"

@implementation FSJGongxiao
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJGongxiao *model = [self mj_objectWithKeyValues:dictionary];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
