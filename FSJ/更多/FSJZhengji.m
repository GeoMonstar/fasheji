//
//  FSJZhengji.m
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJZhengji.h"

@implementation FSJZhengji

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJZhengji *model = [self mj_objectWithKeyValues:dictionary];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
