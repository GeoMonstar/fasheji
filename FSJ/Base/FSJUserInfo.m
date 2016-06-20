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
          _shareObj =  [self checkdatabase:_shareObj];
    });
    return _shareObj;
}
+ (FSJUserInfo *)checkdatabase:(FSJUserInfo *)model{
    
    NSDictionary *dic = (NSDictionary *)[[EGOCache globalCache]objectForKey:@"userinfo"];
    
    FSJUserInfo *usermodel = [self mj_objectWithKeyValues:dic];
    
    return usermodel;
    
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
