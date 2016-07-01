//
//  Header.h
//  FSJ
//
//  Created by Monstar on 16/6/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#ifndef Header_h
#define Header_h
#define  HORIZONTAL_LINE(grayView,x,y,color,super_view)   UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(x, y, JDScreenWidthCurOri, 1)];grayView.backgroundColor=color;[super_view addSubview:grayView];

#define MYLABEL(label,X,Y,WIDTH,HEIGHT,text_s,NST,fontSize,color,numberOfLs,super_view)  UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X, Y, WIDTH, HEIGHT)];label.text=text_s;label.textAlignment=NST;label.font=[UIFont systemFontOfSize:fontSize];label.textColor=color;label.numberOfLines=numberOfLs;[super_view addSubview:label];

#define MYLABEL_(label,X,Y,WIDTH,HEIGHT,text_s,NST,fontSize,color,numberOfLs,super_view)  label=[[UILabel alloc]initWithFrame:CGRectMake(X, Y, WIDTH, HEIGHT)];label.text=text_s;label.textAlignment=NST;label.font=[UIFont systemFontOfSize:fontSize];label.textColor=color;label.numberOfLines=numberOfLs;[super_view addSubview:label];

#define MYBUTTON(button,X,Y,WIDTH,HEIGHT,normalColor,title,selector,BGCOLOR,TAG,size,title_selColor,selTitle,super_view)  UIButton *button=[UIButton  buttonWithType:UIButtonTypeCustom];button.frame=CGRectMake(X, Y, WIDTH, HEIGHT);[button setTitleColor:normalColor forState:UIControlStateNormal];[button setTitle:title forState:UIControlStateNormal];[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];button.backgroundColor=BGCOLOR;button.tag=TAG;button.titleLabel.font=[UIFont systemFontOfSize:size];[button setTitleColor:title_selColor forState:UIControlStateSelected];[button setTitle:selTitle forState:UIControlStateSelected];[super_view addSubview:button];

#define MYBUTTON_(button,X,Y,WIDTH,HEIGHT,normalColor,title,selector,BGCOLOR,TAG,title_selColor,selTitle,super_view)  button=[UIButton  buttonWithType:UIButtonTypeCustom];button.frame=CGRectMake(X, Y, WIDTH, HEIGHT);[button setTitleColor:normalColor forState:UIControlStateNormal];[button setTitle:title forState:UIControlStateNormal];[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];button.backgroundColor=BGCOLOR;button.tag=TAG;[button setTitleColor:title_selColor forState:UIControlStateSelected];[button setTitle:selTitle forState:UIControlStateSelected];[super_view addSubview:button];

#define MYTABLEVIEW_(tableview,X,Y,WIDTH,HEIGHT,TableViewStyle,bgColor,sepColor,super_view)   tableview=[[UITableView alloc]initWithFrame:CGRectMake(X,Y,WIDTH,HEIGHT) style:UITableViewStylePlain];tableview.delegate=self;tableview.dataSource=self;tableview.backgroundColor=bgColor;tableview.separatorColor=sepColor;[super_view addSubview:tableview];

#define MYVIEW(view,X,Y,WIDTH,HEIGHT,bgColor,super_view)   UIView *view=[[UIView alloc]initWithFrame:CGRectMake(X,Y,WIDTH,HEIGHT)];view.backgroundColor=bgColor;[super_view addSubview:view];

#define MYVIEW_(view,X,Y,WIDTH,HEIGHT,bgColor,super_view)   view=[[UIView alloc]initWithFrame:CGRectMake(X,Y,WIDTH,HEIGHT)];view.backgroundColor=bgColor;[super_view addSubview:view];


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

#define MergeStr(str,model)  [NSString stringWithFormat:@"%@:%@",str,model]
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
//#define BaseURL           @"http://119.6.203.24:8099/fsj"
#define BaseUploadURL   @""
#else
#define BaseURL         @"http://192.168.10.94:8080/fsj"
//#define BaseURL           @"http://119.6.203.24:8099/fsj"
//#define BaseUploadURL @""
#endif
#define BaseTongjiurl(username)  [NSString stringWithFormat:@"http://192.168.10.94:8080/fsj/alarm/app/statistics?userName=%@",username];
#define BaseImgURL      @"http://192.168.10.94:8080"
//#define BaseImgURL        @"http://119.6.203.24:8099/fsj"
#define PgyAppID        @"85838383eb2e34b6a2b49fa95c94be8b"
#define THWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
///Users/jiangdake/Library/Developer/Xcode/DerivedData
#define AccountChanged @"该用户已在其他设备登录"

#endif /* Header_h */
