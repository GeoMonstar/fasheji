//
//  FSJMineTableViewCell.h
//  FSJ
//
//  Created by Monstar on 16/3/11.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSJMineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserInfoIcon;
@property (weak, nonatomic) IBOutlet UILabel *UserInfoname;
@property (weak, nonatomic) IBOutlet UILabel *UserInfocontent;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;



@end
