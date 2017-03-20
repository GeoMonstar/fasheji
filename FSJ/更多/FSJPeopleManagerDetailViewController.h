//
//  FSJPeopleManagerDetailViewController.h
//  FSJ
//
//  Created by Monstar on 16/3/17.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailInfoType){
    WarningDetail = 0 ,
    WarnedDetail,
    TongjiDetail,
    PeopleManageDetail,
    StationManageDetail,
    FSJManageDetail
};
@interface FSJPeopleManagerDetailViewController : FSJBaseViewController


@property (nonatomic,assign)DetailInfoType DetailInfoType;

@property (nonatomic ,copy)NSString *managerID;
@end
