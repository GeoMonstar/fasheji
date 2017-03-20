//
//  FSJMineTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/3/11.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMineTableViewCell.h"

@implementation FSJMineTableViewCell
@synthesize UserInfoIcon = _UserInfoIcon;
@synthesize UserInfoname = _UserInfoname;
@synthesize UserInfocontent = _UserInfocontent;
@synthesize checkLabel = _checkLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
