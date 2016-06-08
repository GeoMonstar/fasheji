//
//  FSJNoDataTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/6/2.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJNoDataTableViewCell.h"

@implementation FSJNoDataTableViewCell
@synthesize TopLabel = _TopLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (FSJNoDataTableViewCell *)initWith:(UITableView *)tableView{
    static NSString *ID = @"FSJNoDataTableViewCell";
    FSJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FSJNoDataTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
