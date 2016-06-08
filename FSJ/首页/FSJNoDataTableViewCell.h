//
//  FSJNoDataTableViewCell.h
//  FSJ
//
//  Created by Monstar on 16/6/2.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSJNoDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TopLabel;

+ (FSJNoDataTableViewCell *)initWith:(UITableView *)tableView;
@end
