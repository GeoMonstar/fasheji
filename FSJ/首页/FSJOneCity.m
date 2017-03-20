//
//  FSJOneCity.m
//  FSJ
//
//  Created by Monstar on 16/3/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJOneCity.h"

@implementation FSJOneCity


+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJOneCity *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end
