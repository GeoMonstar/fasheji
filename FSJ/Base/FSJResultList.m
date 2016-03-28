//
//  FSJResultList.m
//  FSJ
//
//  Created by Monstar on 16/3/8.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJResultList.h"

@implementation FSJResultList


//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID":@"id",@"descript":@"description"};
}
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    FSJResultList *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;
    
}
@end
