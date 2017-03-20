//
//  FSJDetailTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/4/15.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJDetailTableViewCell.h"

@implementation FSJDetailTableViewCell
@synthesize headView = _headView;
@synthesize topLabel = _topLabel;
@synthesize secondLabel = _secondLabel;
@synthesize thridLabel = _thridLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
