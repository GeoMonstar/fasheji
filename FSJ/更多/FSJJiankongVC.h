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
@interface FSJJiankongVC : FSJBaseViewController

@property (nonatomic,assign)JiankongType JiankongType ;
@property (nonatomic,copy)NSString *fsjId;
@property (nonatomic,copy)NSString *addressId;
@property (nonatomic,assign)BOOL showZidong;
@property (nonatomic,assign)BOOL is1000W;
@end
