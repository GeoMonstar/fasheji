//
//  FSJOneFSJTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJOneFSJTableViewCell.h"

@implementation FSJOneFSJTableViewCell
@synthesize topLabel = _topLabel;
@synthesize rusheValue = _rusheValue;
@synthesize fansheValue = _fansheValue;
@synthesize fsjImg = _fsjImg;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
