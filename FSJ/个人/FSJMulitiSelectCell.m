//
//  FSJMulitiSelectCell.m
//  FSJ
//
//  Created by Monstar on 16/6/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMulitiSelectCell.h"
@interface FSJMulitiSelectCell ()
//选中按钮
@property (nonatomic,strong) UIButton *selectBtn;

@end
@implementation FSJMulitiSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
        
    }
    return self;
}


- (void)createView{
    self.TopLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 44)];
    self.TopLabel.font=[UIFont systemFontOfSize:14];
    self.TopLabel.textAlignment = NSTextAlignmentLeft;
   
    [self.contentView addSubview:self.TopLabel];
   
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(WIDTH - 35, 15, 20, 20);
    self.selectBtn.selected = self.customSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.selectBtn];
    
    
    _bigSelectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _bigSelectBtn.frame = CGRectMake(0, 0, WIDTH , 44);
    _bigSelectBtn.backgroundColor = [UIColor clearColor];
    [_bigSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_bigSelectBtn];
    
}
-(void)reloadCell{
    self.selectBtn.selected = self.customSelected;
    
}

//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.customSelectedBlock) {
        self.customSelectedBlock(self.selectBtn.selected);
    }
    
}

@end
