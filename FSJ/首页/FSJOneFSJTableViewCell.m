//
//  FSJOneFSJTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJOneFSJTableViewCell.h"
#import "FSJOneFSJ.h"
@implementation FSJOneFSJTableViewCell
@synthesize topLabel = _topLabel;
@synthesize rusheValue = _rusheValue;
@synthesize fansheValue = _fansheValue;
@synthesize fsjImg = _fsjImg;
- (void)awakeFromNib {
    // Initialization code
}
- (void)setItem:(FSJOneFSJ *)item{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.topLabel.text = item.name;
    self.rusheValue.text = item.masterPo;
    self.rusheValue.textColor = SystemGreenColor;
    self.fansheValue.text = item.masterPr;
    self.fansheValue.textColor = SystemGreenColor;
    self.fsjImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.fsjImg sizeToFit];
    switch ([item.status integerValue]) {
        case 0:
            self.fsjImg.image = [UIImage imageNamed:@"APPgreen"];
            break;
        case 1:
            self.fsjImg.image = [UIImage imageNamed:@"APPred"];
            break;
        case 2:
            self.fsjImg.image = [UIImage imageNamed:@"APPyellow"];
            break;
        case 3:
            self.fsjImg.image = [UIImage imageNamed:@"APPhui"];
            break;
        default:
            break;
    }


}
+ (FSJOneFSJTableViewCell *)initWith:(UITableView *)tableView{
    static NSString *ID = @"CELL";
    FSJOneFSJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FSJOneFSJTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
