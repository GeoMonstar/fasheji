//
//  PopcellviewTableViewCell.m
//  FSJ
//
//  Created by Monstar on 16/4/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "PopcellviewTableViewCell.h"

@implementation PopcellviewTableViewCell
@synthesize nameLabel = _nameLabel;
@synthesize imgView = _imgView;
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.nameLabel.textColor = [UIColor blackColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
+ (instancetype) cellAllocWithTableView:(UITableView *)tableView {
    
    PopcellviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
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
