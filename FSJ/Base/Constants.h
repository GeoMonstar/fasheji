//
//  Constants.h
//  Ujifu
//
//  Created by JUNN on 15/7/17.
//  Copyright (c) 2015年 JUNN. All rights reserved.
//

#ifndef Ujifu_Constants_h
#define Ujifu_Constants_h
/**
 *  @brief  颜色以及字体大小管理
 */
//#define Font_GlobalTitle    [UIFont fontWithName:@"Helvetica" size:17.0f]
#define Font_GlobalTitle    [UIFont systemFontOfSize:16.0f]
#define Font_GlobalContent  [UIFont systemFontOfSize:15.0f]
#define Font_GlobalMark     [UIFont systemFontOfSize:14.0f]
#define Font_GlobalMine     [UIFont systemFontOfSize:12.0f]
#define Color_GlobalLine    UIColorFromRGB(0xD8D8D8)
#define Color_GlobalTitle   UIColorFromRGB(0x585858)
#define Color_GlobalContent UIColorFromRGB(0xA3A3A3)
#define Color_GlobalMark    UIColorFromRGB(0xA3A3A3)
#define Color_GlobalTableBG    UIColorFromRGB(0xF1F1F1)
#define Color_GlobalButtonBG UIColorFromRGB(0x00A0EA)
#define Color_GlobalNaveBG UIColorFromRGB(0x313435)
#define Color_GlobalLoginPlacehoder UIColorFromRGB(0xB3B3B3)
#ifdef __OBJC__
//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif

#define UIColorWithRGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define UIColorWithRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define ViewWidth self.view.frame.size.width
#define ViewHeight self.view.frame.size.height

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define GloableLan UIColorFromRGB(0x00a0ea)

//weakSelf宏
#define THWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

//调试宏
//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"优积付:%s 行号:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif
//设备判断

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//应用版本号
#define APPVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define APPBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//滴滴渠道号
#define DIDICHANEL 55133
#define DIDIURL @"http://webapp.diditaxi.com.cn/?"
//e代驾
#define EDAIJIA  @"01050273"
#define EDAIJIATEST @"http://h5.d.edaijia.cn/app/index.html?from=test"
#define EDAIJIAURL @"http://h5.edaijia.cn/app/index.html?"
//http://h5.edaijia.cn/app/index.html?from=01050273

//百度账号：iyoocapp@iyooc.cn 密码：iyooc20150713
//友盟：http://www.umeng.com/    账号：iyoocapp@iyooc.cn ，密码：iyooc20150713
//云测：http://www.testin.cn/         账号：iyoocapp@iyooc.cn ，密码：iyooc20150713
//个推: https://dev.getui.com/   账号:iyoocapp ,密码:iyooc20150713

//个人发布
//#define BAIDUMAPKEY @"2qGUhT17wqnZmTVzyxEZMrWK"
#define BAIDUMAPKEY @"lEAjGRmrUwmsOAMdwuEaqirF"

//企业发布
//#define BAIDUMAPKEY @"GMC3bOLj78Mf6HGc8eK50Gae"

//个人账号测试
//#define GETUIAppId           @"filpN5xxrX9KZOCFSETgHA"
//#define GETUIAppKey          @"Q033V9MUfr7V6hC2JQO6P3"
//#define GETUIAppSecret       @"lWz84MmQ2o9hTe8AoWl5g"
//个人账号正式
//#define GETUIAppId           @"elWje9HvXcAYEoQReumVp5"
//#define GETUIAppKey          @"16SiIpsGrv7BqBjaWQKmA7"
//#define GETUIAppSecret       @"MDGBJd9Wrb55NfDs2cPuh7"
//企业账号正式
#define GETUIAppId           @"J6CL4JJpXy58oKAreM7w82"
#define GETUIAppKey          @"vfH5tbfbl09IPDbmB6Sv97"
#define GETUIAppSecret       @"e6CnigbK1L7UqqB42IP3N1"

//支付成功监听地址 //判断包含paysuccess 不包括returnurl
#define PayClient            @"client_back_native"
#define PaySuccesAndBackMsg  @"resp_result=success"
#define PayFailAndBackMsg    @"resp_result=fail"
#define RETURNURL            @"return_url"
#define ChargeSuccess        @"ChargeSuccess"
#define ChargeReturnUrl      @"ios_u_point_pay"
#define app_url              @"http://return_weixin_diaoyong"
//tableviewcell 分隔线颜色 //黑色 10%
#define UITABLEVIEWSEPARATEBLACKCOLOR  UIColorWithRGBA(0, 0, 0, 0.1);
//白色
#define UITABLEVIEWSEPARATEWHITECOLOR  UIColorFromRGBWithAlpha(0xFFFFFF,1);


#define UITABLEVIEWLINEVIEW(XPOSTION,CEllHEIGHT,COLOR){\
UIView* lineV = [[UIView alloc] initWithFrame:CGRectMake(XPOSTION, CEllHEIGHT-0.35, ViewWidth-XPOSTION*2, 0.35)];\
[cell.contentView addSubview:lineV];\
lineV.backgroundColor = COLOR;\
}
#define UITABLEVIEWHEADLINEVIEW(XPOSTION,CEllHEIGHT,COLOR){\
UIView* lineV1 = [[UIView alloc] initWithFrame:CGRectMake(XPOSTION,0, ViewWidth-XPOSTION*2, 0.35)];\
[cell.contentView addSubview:lineV1];\
lineV1.backgroundColor = COLOR;\
}

#define UITABLEVIEWLINERIGHTVIEW(XPOSTION,CEllHEIGHT,COLOR){\
UIView* lineV = [[UIView alloc] initWithFrame:CGRectMake(XPOSTION, CEllHEIGHT-0.5, ViewWidth, 0.5)];\
[cell.contentView addSubview:lineV];\
lineV.backgroundColor = COLOR;\
}
//数据缓存时间
#define CacheTime  (7*24*60*60)
//验证码重发时间
#define VeriCodeTime  60
//左侧菜单栏配置参数
#define  LeftMenuConfigValue 65
//默认定位城市
#define PlaceArgument @"重庆"
#define EditionNo [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]

#define IPSERVER @"http://app.artocarpus.cn:10304/"

#endif
