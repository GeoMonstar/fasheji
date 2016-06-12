//
//  FSJOneFSJTableViewCell.h
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShebeiClicked)(void);
@class FSJOneFSJ;
@interface FSJOneFSJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *rusheValue;
@property (weak, nonatomic) IBOutlet UILabel *fansheValue;
@property (weak, nonatomic) IBOutlet UIImageView *fsjImg;
@property (nonatomic, strong)FSJOneFSJ *item;
@property (weak, nonatomic) IBOutlet UIButton *ShebeiBtn;
@property (copy,nonatomic)ShebeiClicked ShebeiClicked;

+ (FSJOneFSJTableViewCell *)initWith:(UITableView *)tableView;
+ (instancetype)cellAllocWithTableView:(UITableView *)tableView;
@end
