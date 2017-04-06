//
//  JQAPIConfigure.m
//  GospellLive
//
//  Created by Monstar on 16/8/24.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "JQAPIConfigure.h"

@implementation JQAPIConfigure

+ (NSURL*)getUrlWith:(NSString *)str{
    NSString * URLPath = [NSString stringWithFormat:@"%@%@",BaseURL,str];
    NSURL * URL = [NSURL URLWithString:URLPath];
    return URL;
    
}

/***********用户管理***********/
+ (NSURL * __nonnull)loginURL
{
   return  [self getUrlWith:Login];
}
+ (NSURL * __nonnull)registerURL{
    
    return [self getUrlWith:Register];
    
}
+ (NSURL * __nonnull)getUserInfoURL{
    
    return [self getUrlWith:GetUserInfo];
}
+ (NSURL * __nonnull)updateUserInfoURL{
    
    return [self getUrlWith:UpdateUserInfo];
}
+ (NSURL * __nonnull)changePasswordURL{
   
    return [self getUrlWith:ChangePassword];
}
+ (NSURL * __nonnull)photoURL{
    
    return [self getUrlWith:Photo];
}
+ (NSURL * __nonnull)logoutURL{
    
    return [self getUrlWith:Logout];
}
+ (NSURL * __nonnull)forgetPwdURL{
    
    return [self getUrlWith:ForgetPwd];
}
+ (NSURL * __nonnull)getMessageURL{
    
    return [self getUrlWith:GetMessageURL];
}


/***********用户管理***********/
+ (NSURL * __nonnull)hotVideoURL{
    
    return [self getUrlWith:HotVideo];
}

+ (NSURL * __nonnull)searchVideoURL{
    
    return [self getUrlWith:SearchVideo];
}
/***********点播***********/
+ (NSURL * __nonnull)sonCategoryURL{
    
    return [self getUrlWith:SonCategory];
}

+ (NSURL * __nonnull)gandsonCategoryURL{

    return [self getUrlWith:GandsonCategory];
}
+ (NSURL * __nonnull)categoryListURL{

    return [self getUrlWith:Categorylist];
}
+ (NSURL * __nonnull)viedoCategoryURL{

    return [self getUrlWith:ViedoCategory];
}
+ (NSURL * __nonnull)viedoDetailURL{

    return [self getUrlWith:ViedoDetail];
}
+ (NSURL * __nonnull)oneViedoDetailURL{
    return [self getUrlWith:OneViedoDetail];
}
+ (NSURL * __nonnull)viedoDetailPageURL{
    return [self getUrlWith:ViedoDetailPage];
}
+ (NSURL * __nonnull)videoCheckURL{
    
    return [self getUrlWith:VideoCheck];
}
+ (NSURL * __nonnull)videoPaymentURL{

    return [self getUrlWith:VideoPayment];
}

+ (NSURL * __nonnull)videoRecommandURL{
    
    return [self getUrlWith:VideoRecommand];
}
/***********个人中心***********/
+ (NSURL * __nonnull)accountBalanceURL{
    
    return [self getUrlWith:AccountBalance];
}
+ (NSURL * __nonnull)accountHistoryURL{
    
    return [self getUrlWith:AccountHistory];
}
+ (NSURL * __nonnull)watchHistoryURL{
    
    return [self getUrlWith:WatchHistory];
}
/***********收藏***********/
+ (NSURL * __nonnull)collectSaveURL{
    return [self getUrlWith:CollectionSave];
}
+ (NSURL * __nonnull)collectListURL{
    return [self getUrlWith:CollectionList];
}
+ (NSURL * __nonnull)collectDeleteURL{
    return [self getUrlWith:CollectionDelete];
}
+ (NSURL * __nonnull)collectCheckURL{
    return [self getUrlWith:CollectionCheck];
}
/***********支付***********/
+ (NSURL * __nonnull)getOrderURL{
    return [self getUrlWith:GetOrder];
}


+ (NSURL * __nonnull)safePayURL
{
    return [self getUrlWith:SafePay];
  
}
+ (NSURL * __nonnull)weChatPayURL
{
    return [self getUrlWith:WeChatPay];
}

+(NSURL *)resultwechatPayURL
{
    return [self getUrlWith:OrderWxPayState];

}

+ (NSURL * __nonnull)changeCurrentPayTypeURL
{
    return [self getUrlWith:ChangeCurrentPayType];

}
/***********弹幕***********/
+ (NSURL * __nonnull)danmulistURL
{
    return [self getUrlWith:GetdanmuList];
    
}
+ (NSURL * __nonnull)senddanmuURL
{
    return [self getUrlWith:Senddanmu];
    
}


@end
