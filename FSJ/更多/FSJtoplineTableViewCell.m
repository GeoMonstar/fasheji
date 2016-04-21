//
//  FSJtopTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/4/21.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJtoplineTableViewCell.h"

@implementation FSJtoplineTableViewCell
@synthesize topLabel = _topLabel;
@synthesize topImg = _topImg;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
