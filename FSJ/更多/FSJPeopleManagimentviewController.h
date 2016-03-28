//
//  FSJPeopleManagimentviewController.h
//  FSJ
//
//  Created by Monstar on 16/3/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FSJPeopleManagimentviewController : UIViewController
typedef NS_ENUM(NSInteger, MoreInfoType){
    Warning = 0 ,
    Warned,
    Tongji,
    PeopleManage,
    StationManage,
    FSJManage
    
};
@property (nonatomic,assign)MoreInfoType InfoType;
//+ (NSString *)actionWithMoreInfoType:(MoreInfoType)actionType;
@end
