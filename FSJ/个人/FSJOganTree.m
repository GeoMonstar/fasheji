//
//  FSJOganTree.m
//  FSJ
//
//  Created by Monstar on 16/6/7.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJOganTree.h"

@implementation FSJOganTree
+ (instancetype)initWithDictionary:(NSDictionary *)dic{
    FSJOganTree *model = [self mj_objectWithKeyValues:dic];
    return model;
}
@end
