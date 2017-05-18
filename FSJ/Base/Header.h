//
//  Header.h
//  FSJ
//
//  Created by Monstar on 16/6/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#ifndef Header_h
#define Header_h


// 懒加载
#define FSJ_LAZY(object, assignment) (object = object ?: assignment)
// 日志输出
#ifdef DEBUG
#define VVDLog(format, ...) NSLog((@"\n[函数名:%s]" "[行号:%d]  \n" format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define VVDLog(format, ...);
#endif

#define PUSHVC(JDAboutMeViewController)   JDAboutMeViewController *aboutMeVC = [[JDAboutMeViewController alloc]init];[self.navigationController pushViewController:aboutMeVC animated:YES];

#define POPVC  [self.navigationController popViewControllerAnimated:YES];

#ifndef W_H_
#define W_H_
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGH [UIScreen mainScreen].bounds.size.height
#endif
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define SystemBlueColor [UIColor colorWithRed:(53/255.0) green:(166/255.0) blue:(187/255.0) alpha:1]
#define SystemLightBlueColor [UIColor colorWithRed:(53/255.0) green:(166/255.0) blue:(187/255.0) alpha:0.86]
#define SystemGrayColor [UIColor colorWithRed:(117/255.0) green:(117/255.0) blue:(117/255.0) alpha:1]
#define SystemWhiteColor [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]
#define SystemGreenColor [UIColor colorWithRed:(130/255.0) green:(191/255.0) blue:(21/255.0) alpha:1]
#define SystemLightGrayColor [UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(244/255.0) alpha:1]
#define SystemYellowColor [UIColor colorWithRed:(245/255.0) green:(206/255.0) blue:(88/255.0) alpha:1]
#define SystemGreenColor [UIColor colorWithRed:(112/255.0) green:(178/255.0) blue:(52/255.0) alpha:1]

#define MergeStr(str,model)  [NSString stringWithFormat:@"%@:%@",str,model]
#define MergeStr1(str,model)  [NSString stringWithFormat:@"%@%@",str,model]
#define MergeStr2(str,model)  [NSString stringWithFormat:@"%@:  %@",str,model]
#define PopviewCellheight [UIScreen mainScreen].bounds.size.height * 0.1
#define Popviewheight [UIScreen mainScreen].bounds.size.height
#define Popviewwidth [UIScreen mainScreen].bounds.size.width
#define SecondArrStr @"城市"
#define ThirdArrStr @"地区"
#define LoginTime 60*60*24*7
//weakSelf宏
#define FSJWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

#ifdef DEBUG

#define BaseURL         @"http://192.168.10.94:8080/fsj"
#define BaseImgURL      @"http://192.168.10.94:8080"
#define BaseTongjiurl(username)  [NSString stringWithFormat:@"http://192.168.10.94:8080/fsj/alarm/app/statistics?userName=%@",username];
#else

#define BaseURL         @"http://125.71.217.109:6688/fsj"
#define BaseImgURL      @"http://125.71.217.109:6688"
#define BaseTongjiurl(username)  [NSString stringWithFormat:@"http://125.71.217.109:6688/fsj/alarm/app/statistics?userName=%@",username];
//#define BaseTongjiurl(username)  [NSString stringWithFormat:@"http://47.89.38.215:6688/fsj/alarm/app/statistics?userName=%@",username];
//#define BaseImgURL      @"http://47.89.38.215:6688"
//#define BaseURL         @"http://47.89.38.215:6688/fsj"


#endif
#define PgyAppID        @"85838383eb2e34b6a2b49fa95c94be8b"
#define THWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
///Users/Monstar/Library/Developer/Xcode/DerivedData

#define kAccountChanged @"该用户已在其他设备登录"

#define kNotificationWithLogout @"kNotificationWithLogout"

#define kAppIdentifierID @"kAppIdentifierID"

#define kAppUserInfo @"kAppUserInfo"

#define kAppUserAccount @"kAppUserAccount"

#define kAppUserPassKey @"kAppUserPassKey"

#define kAPPUserID @"kAPPUserID"

#define kGestureControl @"kGestureControl"






#endif /* Header_h */
