//
//  LoginTableViewCell.m
//  UJF
//
//  Created by JUNN on 15/7/28.
//  Copyright (c) 2015年 JUNN. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.backgroundColor = [UIColor clearColor];
        }
    }
}
@end
