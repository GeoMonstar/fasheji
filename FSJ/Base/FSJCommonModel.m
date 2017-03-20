//
//  FJSCommonModel.m
//  FSJ
//
//  Created by Monstar on 16/7/18.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJCommonModel.h"

@implementation FSJCommonModel
MJExtensionCodingImplementation
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJCommonModel *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
}
@end
