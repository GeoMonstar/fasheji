//
//  FSJShebeiInfo50W.m
//  FSJ
//
//  Created by Monstar on 2017/3/17.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJShebeiInfo50W.h"

@implementation FSJShebeiInfo50W
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJShebeiInfo50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
+ (NSDictionary *)replacedKeyFromPropertyName

{
    return @{@"idStr": @"id"};
    
}

@end
@implementation FSJTongxinjiekou50W
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJTongxinjiekou50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}


@end
@implementation FSJZhengjistatus50W
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJZhengjistatus50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}


@end

@implementation FSJShebeijiegoul50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJShebeijiegoul50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
- (NSString *)description{
    return  [NSString stringWithFormat:@"电源 == %@ 功放 == %@ 激励器 == %@ 解调 == %@ 输出通道 == %@",_powerNum,_amplifierNum,_actuatorNum,_inputNum,_outputNum];

}
@end
@implementation FSJDianyuan50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJDianyuan50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end

@implementation FSJGongfang50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJGongfang50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end

@implementation FSJJiliqi50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJJiliqi50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end
