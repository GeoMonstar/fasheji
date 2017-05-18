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

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"transmitterType"]) {
        switch ([oldValue integerValue]) {
            case 1:
                return @"模拟电视发射机";
                break;
            case 2:
                return @"调频广播发射机";
                break;
            case 3:
                return @"地面数字电视广播发射机";
                break;
            case 4:
                return @"移动多媒体广播发射机（CMMB）";
                break;
            case 5:
                return @"中波广播发射机";
                break;
            case 6:
                return @"短波广播发射机";
                break;
            case 7:
                return @"短波跳频发射机";
                break;
            case 8:
                return @"收转式地面数字电视广播发射机";
                break;
                
            default:
                break;
        }
    }
    
    if (oldValue == NULL || oldValue == nil) {
        return @"";
    }
    return oldValue;
}
@end
