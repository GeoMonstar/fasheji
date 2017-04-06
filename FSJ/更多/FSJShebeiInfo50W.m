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
@implementation FSJTongdao50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJTongdao50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
- (NSString *)eChOutputLDPCQAM{

    switch ([_eChOutputLDPCQAM integerValue]) {
     
        case 1:
            return @"0.4&4QAM";
            break;
        case 2:
            return @"0.6&4QAM";
            break;
        case 3:
            return @"0.8&4QAM";
            break;
        case 7:
            return @"0.8&4QAMNR";
            break;
        case 9:
            return @"0.4&16QAM";
            break;
        case 10:
            return @"0.6&16QAM";
            break;
        case 11:
            return @"0.8&16QAM";
            break;
        case 12:
            return @"0.8&32QAM";
            break;
        case 13:
            return @"0.4&64QAM";
            break;
        case 14:
            return @"0.6&64QAM";
            break;
        case 15:
            return @"0.8&64QAM";
            break;
        default:
            break;
    }
    return 0;
}
- (NSString *)eChOutputFrameMode{
    switch ([_eChOutputFrameMode integerValue]) {
            
        case 0:
            return @"420";
            break;
        case 1:
            return @"595";
            break;
        case 2:
            return @"945";
            break;
       
        default:
            break;
    }
    return 0;
}
@end

@implementation FSJJietiao50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJJietiao50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end

@implementation FSJZhengjicontrol50W

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJZhengjicontrol50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
}
@end
@implementation FSJDTUnormal50W
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJDTUnormal50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
}

@end
@implementation FSJDTUabNormal50W
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJDTUabNormal50W *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
}

@end
