//
//  FSJMainTableViewDelegate.h
//  FSJ
//
//  Created by Monstar on 16/5/31.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 点击cell事件回调
 */
typedef void(^TableViewDidSelectRowAtIndexPath) (NSIndexPath* indexRow);

@interface FSJMainTableViewDelegate : NSObject<UITableViewDelegate>

/**
 * 对 cell 代理初始化
 */
- (instancetype)initWithDidSelectRowAtIndexPath:(TableViewDidSelectRowAtIndexPath)tableViewDidSelectRowAtIndexPath;





@end
