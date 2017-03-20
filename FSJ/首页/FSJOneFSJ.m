//
//  FSJOneFSJ.m
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJOneFSJ.h"

@implementation FSJOneFSJ


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJOneFSJ *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end
