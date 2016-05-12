//
//  FSJOneFSJTableViewCell.h
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSJOneFSJ;
@interface FSJOneFSJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *rusheValue;
@property (weak, nonatomic) IBOutlet UILabel *fansheValue;
@property (weak, nonatomic) IBOutlet UIImageView *fsjImg;
@property (nonatomic, strong)FSJOneFSJ *item;
+ (FSJOneFSJTableViewCell *)initWith:(UITableView *)tableView;
@end
