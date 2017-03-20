//
//  FSJJKPopView.h
//  FSJ
//
//  Created by Monstar on 16/6/6.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectIndexBlock) (NSInteger index);
typedef void(^Popshow) (BOOL popshow);
@interface FSJJKPopView : UIView

@property (nonatomic,copy)SelectIndexBlock selectIndex;
@property (nonatomic,copy)Popshow popshow;

- (instancetype)initPopWith:(CGRect)frame andDataSource:(NSArray *)data;
@end
