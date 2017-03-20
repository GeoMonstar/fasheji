//
//  FSJMainTableView.m
//  FSJ
//
//  Created by Monstar on 16/5/31.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMainTableView.h"
#import "FSJMainTableViewDelegate.h"
#import "FSJMaintableViewDataSource.h"
#import "FSJOneFSJTableViewCell.h"
#import "FSJOneFSJ.h"
@interface FSJMainTableView()<UITableViewDelegate>
@property (nonatomic, strong) FSJMaintableViewDataSource * tableViewDataSource;
@property (nonatomic, strong) FSJMainTableViewDelegate   * tableViewDelegate;
@end
@implementation FSJMainTableView

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
                         items:(NSMutableArray *)items
                        action:(void(^)(NSIndexPath * index))action{
    if (self = [super initWithFrame:frame]) {
        self.dataArr = items;
        self.action = [action copy];
       
        self.tableViewDataSource = [[FSJMaintableViewDataSource alloc]initWithItems:items cellClass:[FSJOneFSJTableViewCell class] configureCellBlock:^(UITableViewCell *cell, NSObject *model) {
            FSJOneFSJTableViewCell *tableViewCell = (FSJOneFSJTableViewCell *)cell;
            FSJOneFSJ *onemodel = (FSJOneFSJ *)model;
            tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            tableViewCell.topLabel.text = onemodel.name;
            tableViewCell.rusheValue.text = onemodel.masterPo;
            tableViewCell.rusheValue.textColor = SystemGreenColor;
            tableViewCell.fansheValue.text = onemodel.masterPr;
            tableViewCell.fansheValue.textColor = SystemGreenColor;
            tableViewCell.fsjImg.contentMode = UIViewContentModeScaleAspectFit;
            [tableViewCell.fsjImg sizeToFit];
            switch ([onemodel.status integerValue]) {
                case 0:
                    tableViewCell.fsjImg.image = [UIImage imageNamed:@"APPgreen"];
                    break;
                case 1:
                    tableViewCell.fsjImg.image = [UIImage imageNamed:@"APPred"];
                    break;
                case 2:
                    tableViewCell.fsjImg.image = [UIImage imageNamed:@"APPyellow"];
                    break;
                case 3:
                    tableViewCell.fsjImg.image = [UIImage imageNamed:@"APPhui"];
                    break;
                default:
                    break;
            }
        }];
        [self 
        registerNib:[UINib nibWithNibName:@"FSJOneFSJTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FSJOneFSJTableViewCell"];
        self.tableViewDelegate = [[FSJMainTableViewDelegate alloc]initWithDidSelectRowAtIndexPath:^(NSIndexPath* indexRow) {
            if (self.action) {
                self.action(indexRow);
            }
        }];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self.tableViewDataSource;
        //
        self.delegate   = self.tableViewDelegate;
    }
    return self;
}

@end
