//
//  PopcellviewTableViewCell.h
//  FSJ
//
//  Created by Monstar on 16/4/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopcellviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

+ (instancetype)cellAllocWithTableView:(UITableView *)tableView;
@end
