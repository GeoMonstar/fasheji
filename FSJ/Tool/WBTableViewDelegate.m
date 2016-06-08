//
//  WBTableViewDelegate.m
//
//  Created by Transuner on 16/3/9.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBTableViewDelegate.h"

@interface WBTableViewDelegate ()

@property (nonatomic, copy) TableViewDidSelectRowAtIndexPath tableViewDidSelectRowAtIndexPath;

@end
@implementation WBTableViewDelegate


- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}


- (instancetype) initWithDidSelectRowAtIndexPath:(TableViewDidSelectRowAtIndexPath)tableViewDidSelectRowAtIndexPath {
    
    self = [super init];
    
    if (self) {
        self.tableViewDidSelectRowAtIndexPath = [tableViewDidSelectRowAtIndexPath copy];
    }
    return self;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CGAffineTransform transform;
    cell.layer.anchorPoint =  CGPointMake(0.5,1);
    cell.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    
    //设置动画时间为0.25秒,xy方向缩放的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.transform = CGAffineTransformMakeScale(1, 1);
    }];

//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PopviewCellheight;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tableViewDidSelectRowAtIndexPath) {
        self.tableViewDidSelectRowAtIndexPath(indexPath.row);
    }
}
@end
