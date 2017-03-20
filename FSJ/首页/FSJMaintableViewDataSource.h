//
//  FSJMaintableViewDataSource.h
//  FSJ
//
//  Created by Monstar on 16/5/31.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FSJOneFSJTableViewCell.h"
#import "FSJOneFSJ.h"
@class FSJOneFSJTableViewCell,FSJOneFSJ;
/**
 * 由model 设置cell 的回调
 */
typedef void(^TableViewCellConfigureBlock) (UITableViewCell *cell,NSObject *model);
/**
 * 数据源管理类的封装
 */
@interface FSJMaintableViewDataSource : NSObject<UITableViewDataSource>
/**
 *  创建数据源管理
 *
 *  @param anItems             数据源
 *  @param cellClass           cell 类
 *  @param aConfigureCellBlock 设置cell的回调
 */
- (instancetype) initWithItems:(NSArray *)dataArray cellClass:(Class)cellClass configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
@end
