//
//  WBPopMenuView.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuView.h"
#import "WBTableViewDataSource.h"
#import "WBTableViewDelegate.h"
//#import "WBTableViewCell.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "PopcellviewTableViewCell.h"
#define WBNUMBER 6

@interface WBPopMenuView ()
@property (nonatomic, strong) WBTableViewDataSource * tableViewDataSource;
@property (nonatomic, strong) WBTableViewDelegate   * tableViewDelegate;
@end

@implementation WBPopMenuView


- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
                     menuWidth:(CGFloat)menuWidth
                         items:(NSArray *)items
                        action:(void(^)(NSInteger index))action {
    if (self = [super initWithFrame:frame]) {
        self.menuWidth = menuWidth;
        self.menuItem = items;
        self.action = [action copy];
        self.tableViewDataSource = [[WBTableViewDataSource alloc]initWithItems:items cellClass:[PopcellviewTableViewCell class] configureCellBlock:^(UITableViewCell *cell, WBPopMenuModel *model) {
            PopcellviewTableViewCell * tableViewCell = (PopcellviewTableViewCell *)cell;
            tableViewCell.nameLabel.text = model.title;
            tableViewCell.imgView.image  = [UIImage imageNamed:model.image];
        }];
        self.tableViewDelegate = [[WBTableViewDelegate alloc]initWithDidSelectRowAtIndexPath:^(NSInteger indexRow) {
            if (self.action) {
                self.action(indexRow);
            }
        }];
        self.tableView = [[UITableView alloc]initWithFrame:[self menuFramewith:items.count] style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self.tableViewDataSource;
        self.tableView.delegate   = self.tableViewDelegate;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.bounces = NO;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"PopcellviewTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
        [self.tableView setBackgroundColor:UIColor.clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundView.alpha = 0.0f;
        //self.tableView.layer.cornerRadius = 10.0f;
        //self.tableView.layer.anchorPoint = CGPointMake(0.5,1);
        //self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.tableView.transform = CGAffineTransformMakeTranslation(0,Popviewheight *0.9);
        
        self.tableView.rowHeight = PopviewCellheight;
        
        [self addSubview:self.tableView];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}
- (CGRect)menuFramewith:(NSInteger)num {
    
    CGFloat menuX = [UIScreen mainScreen].bounds.size.width/2  - self.menuWidth;
    CGFloat menuY = [UIScreen mainScreen].bounds.size.height - PopviewCellheight * (2.5+num);
    CGFloat width = self.menuWidth;
    CGFloat heigh = PopviewCellheight * (num);
    return (CGRect){menuX,menuY,width,heigh};
}
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [[WBPopMenuSingleton shareManager]hideMenu];
}

@end
