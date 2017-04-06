//
//  FSJScrollBtnView.h
//  FSJ
//
//  Created by Monstar on 2017/4/5.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollviewDidselectd <NSObject>

- (void)scrollviewDidselectdWithSeletedIndex:(NSInteger)index andViewTag:(NSInteger) viewTag;

@end
@interface FSJScrollBtnView : UIView

@property (nonatomic, weak)id<ScrollviewDidselectd> delegate;
- (instancetype)initWithFrame:(CGRect)mainframe
                 andItemFrame:(CGRect)itemFrame
                andtitleColor:(UIColor *)titlecolor
             andselTitleColor:(UIColor *)selTitlecolor
                   andbgColor:(UIColor *)bgColor
                andselBgColor:(UIColor *)selBgColor
                   andviewTag:(NSInteger)viewTag
                andtitleArray:(NSArray *)titleArray
             andViewDirection:(NSInteger)direction;

@end
