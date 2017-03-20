//
//  FSJInterestModel.m
//  FSJ
//
//  Created by Monstar on 16/6/7.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJInterestModel.h"

@implementation FSJInterestModel
@synthesize name = _name;
@synthesize stationId = _stationId;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJInterestModel *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
}
@end
