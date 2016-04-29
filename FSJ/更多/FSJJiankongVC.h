//
//  FSJJiankongVC.h
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JiankongType){
    Qianji = 0,
    Moji,
    Zhengji,
    Zhuangtai
    
};
@interface FSJJiankongVC : UIViewController

@property (nonatomic,assign)JiankongType JiankongType ;
@property (nonatomic,copy)NSString *fsjId;
@property (nonatomic,copy)NSString *addressId;
@end
