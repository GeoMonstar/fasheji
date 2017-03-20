//
//  FSJJiankongBase.m
//  FSJ
//
//  Created by Monstar on 16/4/27.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJJiankongBase.h"

@implementation FSJJiankongBase
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJJiankongBase *model = [self mj_objectWithKeyValues:dictionary];
    return model;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
