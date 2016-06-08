//
//  FSJMulitiSelectCell.h
//  FSJ
//
//  Created by Monstar on 16/6/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomSelectBlock)(BOOL selected);
@interface FSJMulitiSelectCell : UITableViewCell



@property (nonatomic, strong) UILabel *TopLabel;

@property (nonatomic, strong)UIButton *bigSelectBtn;

@property (nonatomic, assign) BOOL customSelected;


@property (nonatomic, copy) CustomSelectBlock customSelectedBlock;
- (void)reloadCell;
@end
