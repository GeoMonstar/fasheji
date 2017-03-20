//
//  FSJJiankong500W.h
//  FSJ
//
//  Created by Monstar on 2017/3/16.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJBaseViewController.h"

typedef NS_ENUM(NSInteger,Jiankong50WType){
    ShebeiInfo,
    TongxinJiekou,
    ZhengjiControl,
    ZhengjiStatus,
    Dianyuan,
    Gongfang,
    Jiliqi
    
};
@interface FSJJiankong50W : FSJBaseViewController

@property (nonatomic,assign)Jiankong50WType jiankong50WType;
@property (nonatomic,copy)NSString *fsjId;
@property (nonatomic,copy)NSString *addressId;

//解调个数
@property (nonatomic,assign)NSInteger inputNum;
//激励器个数
@property (nonatomic,assign)NSInteger actuatorNum;
//输出通道个数
@property (nonatomic,assign)NSInteger outputNum;
//功放个数
@property (nonatomic,assign)NSInteger amplifierNum;
//电源个数
@property (nonatomic,assign)NSInteger powerNum;


@end
