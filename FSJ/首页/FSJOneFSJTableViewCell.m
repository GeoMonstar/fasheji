//
//  FSJOneFSJTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJOneFSJTableViewCell.h"
#import "FSJOneFSJ.h"
@interface FSJOneFSJTableViewCell(){
    NSString *tranID;
}

@end
@implementation FSJOneFSJTableViewCell

@synthesize topLabel = _topLabel;
@synthesize rusheValue = _rusheValue;
@synthesize fansheValue = _fansheValue;
@synthesize fsjImg = _fsjImg;
@synthesize ShebeiBtn = _ShebeiBtn;
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
    tranID = item.transId;
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
   
    if (iPhone5 ||iPhone4) {
         [self.ShebeiBtn setImageEdgeInsets:UIEdgeInsetsMake(-1, 0, -2,30 )];
    }
    else if (iPhone6 ) {
         [self.ShebeiBtn setImageEdgeInsets:UIEdgeInsetsMake(-1, 0, -2,50 )];
    }
    else if (iPhone6plus ) {
        [self.ShebeiBtn setImageEdgeInsets:UIEdgeInsetsMake(-1, 0, -2,75 )];
    }
    
    [self.ShebeiBtn addTarget:self action:@selector(Shebeiclicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)Shebeiclicked:(UIButton *)button{
    
    if (self.ShebeiClicked) {
        self.ShebeiClicked();
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
+ (instancetype) cellAllocWithTableView:(UITableView *)tableView {
    
    FSJOneFSJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSJOneFSJTableViewCell"];
    if (cell == nil) {
        cell = [[[self class] alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass([self class])];
        // cell = [[[self class]alloc]dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
