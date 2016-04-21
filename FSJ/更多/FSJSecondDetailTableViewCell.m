//
//  FSJSecondDetailTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/4/20.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJSecondDetailTableViewCell.h"

@implementation FSJSecondDetailTableViewCell
@synthesize topLabel    = _topLabel;
@synthesize secondLabel = _secondLabel;
@synthesize thirdLabel  = _thirdLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
