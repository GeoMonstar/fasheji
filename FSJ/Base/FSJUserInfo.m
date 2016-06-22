//
//  FSJUserInfo.m
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJUserInfo.h"
#import "FSJDES.h"
#import <SSKeychain.h>
#import "NSString+RegexCategory.h"
@implementation FSJUserInfo

+ (FSJUserInfo *)shareInstance{
    static FSJUserInfo *_shareObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          _shareObj =  [[FSJUserInfo alloc]init];
    });
    return _shareObj;
}

- (void)setModel:(FSJUserInfo *)usermodel{


}

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    FSJUserInfo *model = [self mj_objectWithKeyValues:dictionary];
    
    return model;

}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (oldValue == nil) {
        return @"";
    }
    return oldValue;
}
@end
