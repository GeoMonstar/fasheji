//
//  JQAPIConfigure.h
//  GospellLive
//
//  Created by Monstar on 16/8/24.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQAPIConstants.h"
@interface JQAPIConfigure : NSObject

//用户管理
+ (NSURL * __nonnull)loginURL;
+ (NSURL * __nonnull)registerURL;
+ (NSURL * __nonnull)getUserInfoURL;
+ (NSURL * __nonnull)updateUserInfoURL;
+ (NSURL * __nonnull)changePasswordURL;
+ (NSURL * __nonnull)photoURL;
+ (NSURL * __nonnull)logoutURL;
+ (NSURL * __nonnull)forgetPwdURL;
+ (NSURL * __nonnull)getMessageURL;
//首页
+ (NSURL * __nonnull)hotVideoURL;
+ (NSURL * __nonnull)searchVideoURL;
//点播
+ (NSURL * __nonnull)sonCategoryURL;
+ (NSURL * __nonnull)gandsonCategoryURL;
+ (NSURL * __nonnull)categoryListURL;
+ (NSURL * __nonnull)viedoCategoryURL;
+ (NSURL * __nonnull)viedoDetailURL;
+ (NSURL * __nonnull)viedoDetailPageURL;
+ (NSURL * __nonnull)oneViedoDetailURL;
+ (NSURL * __nonnull)videoCheckURL;
+ (NSURL * __nonnull)videoPaymentURL;
+ (NSURL * __nonnull)videoRecommandURL;
//个人中心
+ (NSURL * __nonnull)accountBalanceURL;
+ (NSURL * __nonnull)accountHistoryURL;
+ (NSURL * __nonnull)watchHistoryURL;
//收藏
+ (NSURL * __nonnull)collectSaveURL;
+ (NSURL * __nonnull)collectListURL;
+ (NSURL * __nonnull)collectDeleteURL;
+ (NSURL * __nonnull)collectCheckURL;
//支付
+ (NSURL * __nonnull)getOrderURL;

+ (NSURL * __nonnull)safePayURL;
+ (NSURL * __nonnull)weChatPayURL;
+ (NSURL * __nonnull)resultwechatPayURL;
+ (NSURL * __nonnull)changeCurrentPayTypeURL;
+ (NSURL * __nonnull)genaratorfeeorderURL;

//弹幕
+ (NSURL * __nonnull)danmulistURL;
+ (NSURL * __nonnull)senddanmuURL;



@end
