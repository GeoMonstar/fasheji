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
        self.tableViewDataSource = [[WBTableViewDataSource alloc]initWithItems:items cellClass:[PopcellviewTableViewCell class] configureCellBlock:^(PopcellviewTableViewCell *cell, WBPopMenuModel *model) {
            PopcellviewTableViewCell * tableViewCell = (PopcellviewTableViewCell *)cell;
            //tableViewCell.imageView.image =[UIImage imageNamed:model.image];
            //tableViewCell.textLabel.text = model.title;
            tableViewCell.nameLabel.text = model.title;
            tableViewCell.imgView.image = [UIImage imageNamed:model.image];
            
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
    
    CGFloat menuX = [UIScreen mainScreen].bounds.size.width  - self.menuWidth;
    CGFloat menuY = [UIScreen mainScreen].bounds.size.height - PopviewCellheight * (2.5+num);
    CGFloat width = self.menuWidth;
    CGFloat heigh = PopviewCellheight * (num);
    return (CGRect){menuX,menuY,width,heigh};
}
#pragma mark 绘制三角形
//- (void)drawRect:(CGRect)rect
//
//{
//    // 设置背景色
//    [[UIColor whiteColor] set];
//    //拿到当前视图准备好的画板
//    
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    
//    //利用path进行绘制三角形
//    
//    CGContextBeginPath(context);//标记
//    CGFloat location = [UIScreen mainScreen].bounds.size.width-55;
//    CGContextMoveToPoint(context,
//                         location -  10 - 10, 180);//设置起点
//    
//    CGContextAddLineToPoint(context,
//                            location - 2*10 - 10 ,  170);
//    
//    CGContextAddLineToPoint(context,
//                            location - 10 * 3 - 10, 180);
//    
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    
//    [[UIColor whiteColor] setFill];  //设置填充色
//    
//    [[UIColor whiteColor] setStroke]; //设置边框颜色
//    
//    CGContextDrawPath(context,
//                      kCGPathFillStroke);//绘制路径path
//    
//}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [[WBPopMenuSingleton shareManager]hideMenu];
}

@end
