//
//  FSJMainTableView.h
//  FSJ
//
//  Created by Monstar on 16/5/31.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSJMainTableView : UITableView

@property (nonatomic, copy) void(^action)(NSIndexPath * index);
@property (nonatomic, copy) NSMutableArray * dataArr;

- (instancetype) initWithFrame:(CGRect)frame
                         items:(NSArray *)items
                        action:(void(^)(NSIndexPath* index))action;
@end
