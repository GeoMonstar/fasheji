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
- (void)setStatusType:(LoginStatusType)statusType{
    
    _statusType = statusType;
    switch (statusType) {
        case StatusWithLoginOut:
            //self.alertMessage = @"请登录";
            break;
        case StatusWithLogin:
            //self.alertMessage = @"登录成功";
            break;
        default:
            break;
    }
}

- (void)setUsermodel:(FSJCommonModel *)usermodel{
    _usermodel = usermodel;
    
    [self setUserInfomationWithUserName:usermodel.jwt userId:usermodel.userId];
    //注:先改变状态再发送通知
    self.statusType = StatusWithLogin;
    //存入UserInfo
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:usermodel];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:data forKey:kAppUserInfo];
//    [ud synchronize];
    [[EGOCache globalCache]setObject:(NSDictionary *)usermodel forKey:kAppUserInfo];
    //登录后触发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithLogin object:nil];

}


#pragma mark-保持用户密码
- (void)setUserInfomationWithUserName:(NSString *)userName userId:(NSString *)userId{
    
    if ([userName isEqualToString:@""]||userName == nil) {
        userName = @"";
    }
    if ([userId isEqualToString:@""]||userId == nil){
        userId = @"";
    }
    NSString *u = [FSJDES encrypt:userName];
    NSString *i = [FSJDES encrypt:userId];
    [SSKeychain setPassword:u forService:kAppIdentifierID account:kAppUserAccount];
    [SSKeychain setPassword:i forService:kAppIdentifierID account:kAPPUserID];
  
}
- (FSJCommonModel *)userAccount{
    
    //保持有账号
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSData *data = [ud objectForKey:kAppUserInfo];
//    [ud synchronize];
    
    //
    FSJCommonModel *model = (FSJCommonModel *)[[EGOCache globalCache]objectForKey:kAppUserInfo];
    [FSJUserInfo shareInstance].usermodel = model;
    return model;
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
#pragma mark- 账号状态
- (BOOL)userAccountStatus{
    
    NSString  *userID =  [FSJUserInfo shareInstance].userID;
    NSString  *userName = [FSJUserInfo shareInstance].userName;
    
    if (userID && userName && ![userID  isEqual: @""] && ![userName  isEqual: @""]) {
        return YES;
    }
    
    return NO;
}
#pragma mark-获取密码
- (NSString *)passkey{
    NSString *p = [SSKeychain passwordForService:kAppIdentifierID account:kAppUserPassKey];
    if (p == nil) {
        return p;
    }
    p = [FSJDES decrypt:p];
    return p;
}
#pragma mark-获取用户名
- (NSString *)userName{
    NSString *u = [SSKeychain passwordForService:kAppIdentifierID account:kAppUserAccount];
    if (u == nil) {
        return u;
    }
    u = [FSJDES decrypt:u];
    return u;
}

#pragma mark- 获取用户ID
- (NSString *)userID{
    NSString *i = [SSKeychain passwordForService:kAppIdentifierID account:kAPPUserID];
    if (i == nil) {
        return @"";
    }
    i = [FSJDES decrypt:i];
    return i;
}
#pragma mark-删除账号信息
- (void)deleteUserAccount{
    
    [self deleteUsername];
    [self deletePasskey];
    [self deleteUserID];
    self.statusType = StatusWithLoginOut;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kAppUserInfo];
    [ud synchronize];
    //登出后触发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithLogout object:nil];
}
#pragma mark-删除用户名
- (BOOL)deleteUsername{
    
    return [SSKeychain deletePasswordForService:kAppIdentifierID account:kAppUserAccount];
}
#pragma mark-删除密码
- (BOOL)deletePasskey{
    
    return [SSKeychain deletePasswordForService:kAppIdentifierID account:kAppUserPassKey];
}
#pragma mark-删除用户ID
- (BOOL)deleteUserID{
    
    return [SSKeychain deletePasswordForService:kAppIdentifierID account:kAPPUserID];
}
@end
