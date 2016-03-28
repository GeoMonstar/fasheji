//
//  FSJChangePersonInfoViewController.h
//  FSJ
//
//  Created by Monstar on 16/3/17.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ChangeInfoType){
    Username = 0 ,
    Usermobile,
    Userphone,
    Useemail,
    Userpwd
    
};
@interface FSJChangePersonInfoViewController : UIViewController
@property (nonatomic,assign)ChangeInfoType changeType;
@property (nonatomic,strong)NSDictionary *dict;
@end
