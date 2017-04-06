//
//  JQLayoutButton.h
//  GospellLive
//
//  Created by Monstar on 16/10/19.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,JQLayoutButtonSytle) {
    JQLayoutButtonStyleLeftImageRightTitle,
    JQLayoutButtonStyleLeftTitleRightImage,
    JQLayoutButtonStyleUpImageDownTitle,
    JQLayoutButtonStyleUpTitleDownImage
};

@interface JQLayoutButton : UIButton

/// 布局方式
@property (nonatomic, assign) JQLayoutButtonSytle layoutStyle;
/// 图片和文字的间距，默认值8
@property (nonatomic, assign) CGFloat midSpacing;
/// 指定图片size
@property (nonatomic, assign) CGSize imageSize;

@end
