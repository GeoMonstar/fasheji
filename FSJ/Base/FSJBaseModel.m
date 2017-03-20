//
//  FSJBaseModel.m
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJBaseModel.h"

@implementation FSJBaseModel

MJExtensionCodingImplementation
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJBaseModel *model = [FSJBaseModel mj_objectWithKeyValues:dictionary];
    return model;
}
@end
