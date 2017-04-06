//
//  JQAPIConstants.m
//  GospellLive
//
//  Created by Monstar on 16/8/24.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "JQAPIConstants.h"
//用户管理

NSString *const imageHostURL = @"http://192.168.10.94:8080";

NSString *const Login = @"/rs/user/login";

NSString *const Register = @"/rs/user/register";

NSString *const GetUserInfo = @"/rs/app/user/info";

NSString *const UpdateUserInfo = @"/rs/app/user/updateUser";

NSString *const ChangePassword = @"/rs/app/user/changePassword";

NSString *const Photo = @"/rs/user/upload/photo";

NSString *const Logout = @"/rs/app/user/logout";

NSString *const ForgetPwd = @"/rs/user/forgetPassword";

NSString *const GetMessageURL = @"/rs/message/send";
//首页
NSString *const HotVideo = @"/rs/app/video/hot";

NSString *const SearchVideo = @"/rs/app/video/search";
//点播
NSString *const SonCategory = @"/rs/app/category/son";

NSString *const GandsonCategory = @"/rs/app/category/grandson";

NSString *const Categorylist = @"/rs/app/category/list";

NSString *const ViedoCategory = @"/rs/app/video/list";

NSString *const ViedoDetail = @"/rs/app/video/source/list";

NSString *const ViedoDetailPage = @"/rs/app/video/source/list/page";

NSString *const OneViedoDetail = @"/rs/app/video/source/info";

NSString *const VideoCheck = @"/rs/app/play/check";

NSString *const VideoPayment = @"/rs/app/play/pay";

NSString *const VideoRecommand = @"/rs/app/video/recommand";

//个人中心

NSString *const AccountBalance = @"/rs/app/account/info";
NSString *const AccountHistory = @"/rs/app/account/history";
NSString *const WatchHistory   = @"/rs/app/play/watch";


//收藏相关

NSString *const CollectionSave = @"/rs/app/collect/save";
NSString *const CollectionList = @"/rs/app/collect/list";
NSString *const CollectionDelete = @"/rs/app/collect/delete";
NSString *const CollectionCheck = @"/rs/app/collect/check";
//支付
NSString *const GetOrder = @"/rs/app/pay/order";

NSString *const GetFeeAction = @"";
NSString *const GenaratorFeeOrder = @"";
NSString *const SafePay = @"";
NSString *const ChangeCurrentPayType = @"";
NSString *const WeChatPay = @"";
NSString *const OrderWxPayState = @"";
NSString *const OutLogin = @"";
//网页访问白名单
NSString *const WhiteList = @"";

//弹幕
NSString *const GetdanmuList = @"/rs/app/danmu/list";


NSString *const Senddanmu    = @"/rs/app/danmu/save";
