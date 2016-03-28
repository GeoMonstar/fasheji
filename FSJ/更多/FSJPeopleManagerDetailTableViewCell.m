//
//  FSJPeopleManagerDetailTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/3/17.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJPeopleManagerDetailTableViewCell.h"

@implementation FSJPeopleManagerDetailTableViewCell
@synthesize stationName = _stationName;
@synthesize managerName = _managerName;
@synthesize sex = _sex;
@synthesize position = _position;
@synthesize telPhone = _telPhone;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
