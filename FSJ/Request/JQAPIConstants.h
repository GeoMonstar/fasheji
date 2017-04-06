//
//  JQAPIConstants.h
//  GospellLive
//
//  Created by Monstar on 16/8/24.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

/***********用户管理*************/

extern NSString *const imageHostURL;

extern NSString *const Login;//登录

extern NSString *const Register;//注册

extern NSString *const GetUserInfo;//个人信息查看

extern NSString *const UpdateUserInfo;//个人信息修改

extern NSString *const ChangePassword;//密码

extern NSString *const Photo;//上传头像

extern NSString *const Logout;//退出登录

extern NSString *const ForgetPwd;//忘记密码

extern NSString *const GetMessageURL;//验证码短信
/***********首页*************/

extern NSString *const HotVideo;//热点视频

extern NSString *const SearchVideo;//搜索视频

/***********点播*************/


extern NSString *const SonCategory;//视频子分类信息

extern NSString *const GandsonCategory;//视频子孙分类信息

extern NSString *const Categorylist; //

extern NSString *const ViedoCategory;//视频分类信息

extern NSString *const ViedoDetail;//视频详细信息+剧集信息

extern NSString *const ViedoDetailPage;

extern NSString *const OneViedoDetail;//视频详细信息

extern NSString *const VideoCheck;//检测视频资源是否付费

extern NSString *const VideoPayment;//扣费

extern NSString *const VideoRecommand;//推荐

/***********个人中心*************/

extern NSString *const AccountBalance;//账户余额

extern NSString *const AccountHistory;//交易记录

extern NSString *const WatchHistory;//交易记录

/***********收藏相关*************/

extern NSString *const CollectionSave;

extern NSString *const CollectionList;

extern NSString *const CollectionDelete;

extern NSString *const CollectionCheck;

/***********白名单***********/
extern NSString *const WhiteList;


//支付
extern NSString *const GetOrder;

//弹幕
extern NSString *const GetdanmuList;

extern NSString *const Senddanmu;



extern NSString *const SafePay;//支付宝支付
extern NSString *const ChangeCurrentPayType;//修改当前的支付方式
extern NSString *const WeChatPay;//微信支付
extern NSString *const OrderWxPayState;//微信支付结果
extern NSString *const OutLogin;//退出登录

